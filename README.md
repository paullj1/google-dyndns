# Google Dyn DNS

Simple daemon based on
[this](https://gist.github.com/drewchapin/57d7039e30e8cc49e30bdc56a194f5bf)
gist.  Will update Google's Dynamic DNS record with the external IP of the host
on which it runs.

# Deploy:
Replace `USERNAME`, `PASSWORD`, and `YOUR_ACTUAL_HOST` below, and run:
```
echo USERNAME | docker secret create dyn_dns_user -
echo PASSWORD | docker secret create dyn_dns_pass -
curl -sSL https://raw.githubusercontent.com/paullj1/google-dyndns/master/compose.yml | sed 's/yourhost.com/YOUR_ACTUAL_HOST/' | docker stack deploy -c - dyndns
```
