#!/usr/bin/env zsh

# See https://w.amazon.com/bin/view/User/tmdav/TipsAndTricks/AeaRefresher/

# for those who are off corp using mwinit --aea -s:
# while the midway cookie lives for 20 hours, the AEA cookie only lives for 2 hours
# it's not necessary to re-enter midway credentials (password and security key) to refresh the AEA cookie
# credit to those on sage who have posted solutions that have inspired this one

mwcookie="$HOME/.midway/cookie"

if [[ ! -f $mwcookie ]]; then
   echo "Can't update $mwcookie because the file doesn't exist." >&2
   exit 1
fi

cookie=$(/usr/local/amazon/bin/acme_amazon_enterprise_access getAcmeDataLongLived)

if [[ $(jq -r '.Status' <<<"$cookie") != Success ]]; then
   echo "Unable to refresh the AEA cookie with long-lived ACME data. Please re-authenticate with Midway." >&2
   exit 1
fi

echo "Refreshing AEA cookie..."
jwt=$(jq -r '.Jwt' <<<"$cookie")
expires=$(($(date +%s) + 7200))
grep -v amazon_enterprise_access "$mwcookie" >"$mwcookie.new"
for domain in auth.midway.amazon.dev auth.midway.aws.a2z.com auth.midway.aws.dev midway-auth.amazon.com
do
   printf "#HttpOnly_.%s\tTRUE\t/\tTRUE\t%s\tamazon_enterprise_access\t%s\n" "$domain" "$expires" "$jwt" >>"$mwcookie.new"
done
mv -f "$mwcookie.new" "$mwcookie"
