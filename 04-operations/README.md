# Part 04 — Test, Document, and Operate

## Objective

Prove the system works, fix failures safely, and tear down resources.

## Folders

| Folder | Purpose |
|--------|---------|
| [testing/](testing/) | Checklists after each major component |
| [troubleshooting/](troubleshooting/) | Common failure modes |
| [cleanup/](cleanup/) | Destroy resources in safe order |

Detailed runbooks are added as Part 02 and Part 03 steps ship.

## Minimum end-to-end test (when stack is live)

1. `curl http://ALB_DNS/` returns frontend
2. API health via frontend proxy returns 200
3. OpenVPN connects; ping/SSH private frontend IP works
4. From backend host, `psql` to RDS succeeds
5. From backend, `curl -x http://SQUID:8888 https://checkip.amazonaws.com` succeeds
