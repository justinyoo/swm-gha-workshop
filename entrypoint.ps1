Param(
    [string]
    [Parameter(Mandatory=$true)]
    $WebexToken,

    [string]
    [Parameter(Mandatory=$true)]
    $WebexRoomId,

    [string]
    [Parameter(Mandatory=$false)]
    $BodyText = "",

    [string]
    [Parameter(Mandatory=$false)]
    $BodyMarkdown = ""
)

# $response = curl --location --request POST 'https://webexapis.com/v1/messages' `
# --header 'Authorization: Bearer $WebexToken' `
# --header 'Content-Type: application/json' `
# --data-raw '{
#   "roomId": "$WebexRoomId",
#   "text": "$BodyText",
#   "markdown": "$BodyMarkdown"
# }'

# $headers = @{}
# $headers.Add("Authorization", "Bearer $WebexToken")
# # $headers.Add("Content-Type", "application/vnd.api+json")

# # $body = "{ `"roomId`": `"$WebexRoomId`", `"text`": `"$BodyText`", `"markdown`": `"$BodyMarkdown`" }"
# $body = @{ roomId = "$WebexRoomId"; text = "$BodyText"; markdown = "$BodyMarkdown" } | ConvertTo-Json -Compress | ConvertTo-Json
# $body = $body.Replace("\`"", "```"")
# $body

# $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)

# Invoke-RestMethod -Method Post `
#     -Uri https://webexapis.com/v1/messages `
#     -Headers $headers `
#     -ContentType "application/vnd.api+json;charset=utf-8" `
#     -Body $body

$json_template = '{"roomId":"%s","text":"%s","markdown":"%s"}\n'
$json_body = $(printf "$json_template" "$WebexRoomId" "$BodyText" "$BodyMarkdown")

# Send message
curl --location --request POST 'https://webexapis.com/v1/messages' `
    --header "Authorization: Bearer $WebexToken" `
    --header "Content-Type: application/json" `
    --data "$json_body"



# Write-Output "::set-output name=response::$response"
