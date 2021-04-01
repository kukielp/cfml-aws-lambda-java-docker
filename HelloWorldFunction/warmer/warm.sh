#!/bin/bash
cd /var/task/
/lambda-entrypoint.sh cfmldemo.App::handleRequest &
PID=$!
sleep 5
curl -XPOST "http://localhost:8080/2015-03-31/functions/function/invocations" -d '{"body":"eyJ0ZXN0IjoiYm9keSJ9","resource":"\/{proxy+}","path":"\/warm.cfm","httpMethod":"GET","isBase64Encoded":true,"queryStringParameters":{"NAME":"paul"},"requestContext":{"accountId":"123456789012","resourceId":"123456","stage":"prod","requestId":"c6af9ac6-7b61-11e6-9a41-93e8deadbeef","requestTime":"09\/Apr\/2015:12:34:56 +0000","requestTimeEpoch":1428582896000,"identity":{"cognitoIdentityPoolId":null,"accountId":null,"cognitoIdentityId":null,"caller":null,"accessKey":null,"sourceIp":"127.0.0.1","cognitoAuthenticationType":null,"cognitoAuthenticationProvider":null,"userArn":null,"userAgent":"Custom User Agent String","user":null},"path":"\/warm.cfm","resourcePath":"\/{proxy+}","httpMethod":"POST","apiId":"1234567890","protocol":"HTTP\/1.1"}}'
ls -la /tmp
sleep 5
kill -9 $PID
sleep 5
exit 0