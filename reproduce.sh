#!/usr/bin/env bash

cat > entrypoint.sh <<EOF
#!/bin/sh
echo "FAIL im am the parent entrypoint"
exec "\${@}"
EOF

# build parent container with entrypoint
docker build --tag ep-issue:parent . -f-<<EOF
FROM alpine:3.7
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
EOF

# build child container reset entrypoint
docker build --tag ep-issue:child1 -<<EOF
FROM ep-issue:parent
# reset entry point
ENTRYPOINT []
CMD []
EOF

# build same in packer
cat > child2.json <<EOF
{
  "builders": [
    {
      "type": "docker",
      "image": "ep-issue:parent",
      "pull": "false",
      "commit": "true",
      "changes": [
        "ENTRYPOINT []",
        "CMD []"
      ]
    }
  ],
  "post-processors": [
    {
      "type": "docker-tag",
      "repository": "ep-issue",
      "tag": "child2"
    }
  ]
}
EOF

PACKER_LOG=1 packer build child2.json

printf '\nInspecting container entrypoints:\n'

# expect to see an entrypoint
 printf '\nparent entrypoint: ' && docker inspect ep-issue:parent | jq '.[].Config.Entrypoint'

# expect to see NO entrypoint
 printf '\nchild 1 entrypoint: ' && docker inspect ep-issue:child1 | jq '.[].Config.Entrypoint'

# expect to see NO entrypoint
 printf '\nchild 2 entrypoint: ' && docker inspect ep-issue:child2 | jq '.[].Config.Entrypoint'

printf '\nRunning both containers:\n'

# if we ru container, no entrypoint output should be displayed
printf '\nchild 1 result: ' &&docker run --rm ep-issue:child1 true

# same for the packer build
printf '\nchild 2 result: ' &&docker run --rm ep-issue:child2 true

rm -f entrypoint.sh child2.json
