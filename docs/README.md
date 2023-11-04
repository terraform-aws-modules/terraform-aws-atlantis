# Supplemental Documentation

## GitHub

### Authenticated Access via GitHub App

A [GitHub App](https://docs.github.com/en/apps/creating-github-apps/about-creating-github-apps/about-creating-github-apps) can be generated to provide Atlantis access instead of using a GitHub personal access token (PAT):

1. Create a GitHub App and give it a name - that name must be globally unique, and you can change it later if needed.
2. Provide a valid Homepage URL - this can be the atlantis server url, for instance `https://atlantis.mydomain.com`
3. Provide a valid [Webhook URL](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/using-webhooks-with-github-apps). The Atlantis webhook server path is located by default at `https://atlantis.mydomain.com/events`.
4. Generate a [Webhook Secret](https://docs.github.com/en/webhooks/using-webhooks/validating-webhook-deliveries). This is the value supplied to the `ATLANTIS_GH_WEBHOOK_SECRET` in the Atlantis server configuration.
5. Generate a Private Key. This is the value supplied to the `ATLANTIS_GH_APP_KEY` in the Atlantis server configuration.
6. On the App's settings page (at the top) you find the App ID. This is the value supplied to `ATLANTIS_GH_APP_ID` in the Atlantis server configuration.
7. On the Permissions & Events you need to setup all the permissions and events according to [Atlantis documentation](https://www.runatlantis.io/docs/access-credentials.html#github-app)

Now you need to [install the App](https://docs.github.com/en/apps/using-github-apps/installing-your-own-github-app) on your organization.

A self-provisioned GitHub App usually has two parts: the App and the Installation.

The App part is the first step and its where you setup all the requirements, such as authentication, webhook, permissions, etc... The Installation part is where you add the created App to an organization/personal-account. It is on the installation page where you setup which repositories the application can access and receive events from.

Once you have your GitHub App registered you will be able to access/manage the required parameters either through `environment` or `secret` (we strongly suggest supplying these through `secret`):

```hcl
module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"

  # Truncated for brevity ...

  # ECS Container Definition
  atlantis = {
    secrets = [
      {
        name      = "ATLANTIS_GH_APP_ID"
        valueFrom = "<SECRETSMANAGER_ARN>"
      },
      {
        name      = "ATLANTIS_GH_APP_KEY"
        valueFrom =  "<SECRETSMANAGER_ARN>"
      },
      {
        name      = "ATLANTIS_GH_WEBHOOK_SECRET"
        valueFrom =  "<SECRETSMANAGER_ARN>"
      },
    ]
  }
}
```

## GitLab

> TODO

## BitBucket

> TODO
