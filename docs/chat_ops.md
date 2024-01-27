# How to configure Slack

1. Create profile in Slack
2. Get a Slack channel webhook URL
2.1 To get a Slack channel webhook URL, you need to create an Incoming Webhook integration in your Slack workspace. Here's how you can do it:
2.2 Open Slack:
Open Slack and navigate to your workspace.
2.3 Go to App Directory:
Click on the "Apps" option located on the left sidebar.
2.4 Search for Incoming Webhooks:
In the Apps section, search for "Incoming Webhooks" in the search bar at the top.
2.5 Add Configuration:
Once you find the "Incoming Webhooks" app, click on it to open it. Then, click on the "Add to Slack" button to add the integration to your workspace.
2.6 Choose Channel:
Select the channel where you want to post messages using the webhook. Click on the "Add Incoming WebHooks integration" button.
2.7 Copy Webhook URL:
After adding the integration, you'll be redirected to a page where you can configure the webhook. Here, you'll find the Webhook URL. It will look something like this:
```https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX```
Copy this URL as it's your webhook URL.
2.8 Configure Settings (Optional):
You can configure other settings like customizing the name and icon for the webhook. Once you're done, click on the "Save Settings" button.
That's it! You now have the webhook URL for your Slack channel. You can use this URL to send messages to the channel programmatically. Make sure to keep the webhook URL secure and avoid sharing it publicly.

## How to test

```curl -X POST --data-urlencode "payload={\"channel\": \"#devops\", \"username\": \"webhookbot\", \"text\": \"This is posted to #my-channel-here and comes from a bot named webhookbot.\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/XXX/YYY/ZZZ```

![Alt text](/images/slack_channel.png)
