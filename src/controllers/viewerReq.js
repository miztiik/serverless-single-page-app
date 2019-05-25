/**
 * @author  miztiik@github
 */

 //https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-examples.html

'use strict';

function parseCookies(headers) {
    const parsedCookie = {};
    if (headers.cookie) {
        headers.cookie[0].value.split(';').forEach((cookie) => {
            if (cookie) {
                const parts = cookie.split('=');
                parsedCookie[parts[0].trim()] = parts[1].trim();
            }
        });
    }
    return parsedCookie;
}

exports.handler = (event, context, callback) => {
    console.log("Viewer Request Event Called");
    console.log("ViewerRequestEvent: %j", event);
    const request = event.Records[0].cf.request;
    const response = event.Records[0].cf.response;
    const headers = request.headers;

    /* Check for session-id in request cookie in viewer-request event,
     * if session-id is absent, redirect the user to sign in page with original
     * request sent as redirect_url in query params.
     */

    /* Check for session-id in cookie, if present then proceed with request */
    const parsedCookies = parseCookies(headers);
    if (parsedCookies && parsedCookies['session-id']) {
        callback(null, request);
    } else {
        
        
        /* URI encode the original request to be sent as redirect_url in query params */
        /*
        const encodedRedirectUrl = encodeURIComponent(`https://${headers.host[0].value}${request.uri}?${request.querystring}`);
        const response = {
            status: '302',
            statusDescription: 'Found',
            headers: {
                location: [{
                    key: 'Location',
                    value: `http://www.example.com/signin?redirect_url=${encodedRedirectUrl}`,
                }],
            },
        };
        */
    }
    console.log("ViewerRequestEvent: %j", request);
    callback(null, request);
};