#!/bin/bash

echo "vault install #################################################################################" \
    && wget "https://s568sas.storage.yandex.net/rdisk/af8fc42cc9c32bcc49202fece4eaed0f86606c7f30b7a741cdac8fd074bffbba/67bf6219/19jqhjQDgo9xJFxONiq1b-GNxl3F0OnZl8u3wGOQxB2F-LWVhKXhZ61giGdqebsIMSye_-esr6fnQ6fVgwuOUw==?uid=0&filename=vault_1.13.2%2Byckms_linux_amd64.zip&disposition=attachment&hash=C3GeHcMc3vMrWUfXivyKBZbeAuAnlfXx1I%2BFUafupXGF0ZKVrWtV7ij2WuCevSz%2Bq/J6bpmRyOJonT3VoXnDag%3D%3D&limit=0&content_type=application%2Fzip&owner_uid=12324809&fsize=100353259&hid=1748518dd8023dcda05b11330ace56c1&media_type=compressed&tknv=v2&ts=62f100699f840&s=d24dfda3aeaa5a04537b19420b9aa8e10ec58ab771dd83600da1be2fa65f6a33&pb=U2FsdGVkX1-N-XwprD4mXI58TJezxC9lFDA-PU9-NGru9CDy-HS12m6lKiHWEPrKudBPQ7lFLquLrAWVPQs6ePAfKgM-UwRPDY5hsQXBUKA" -O /tmp/vault.zip \
    && unzip /tmp/vault.zip \
    && rm -f /tmp/vault.zip \
    && chmod a+x vault \
    && mv vault /usr/bin/
