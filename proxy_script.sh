#!/bin/bash

# 访问 JSON 状态信息。
# -sS：静默模式，但显示错误。
# 2>&1：将标准错误重定向到标准输出 (这是为了在调试时查看错误)。
# 3>&1 1>&2：这是一个临时技巧，目的是将 curl 的输出 (stdout) 捕获到变量中，
#           同时将 curl 的错误 (stderr) 丢弃到 /dev/null，或者确保它不会干扰变量赋值。
# 
# 最简洁且功能正确的写法：
# 将 curl 的标准错误重定向到 /dev/null，确保变量只捕获标准输出
JSON_RESPONSE=$(curl -sS http://127.0.0.1:8080/status 2>/dev/null)

CURL_EXIT_CODE=$?

# 默认状态为 503
STATUS_LINE="HTTP/1.1 503 Service Unavailable"
HTTP_BODY='{"error": "Internal API is unavailable"}'
CONTENT_TYPE="application/json"

# 检查 CURL 退出码是否为 0 且响应是否以 { 开头（验证是否为 JSON）
if [ $CURL_EXIT_CODE -eq 0 ] && [[ "$JSON_RESPONSE" == *{* ]]; then
    # JQ 处理：将 JSON 管道给 JQ，并检查 JQ 的退出码
    HTTP_BODY=$(echo "$JSON_RESPONSE" | jq -c '{isStop, nowUrl, prevUrl}')
    JQ_EXIT_CODE=$?
    
    if [ $JQ_EXIT_CODE -eq 0 ]; then
        STATUS_LINE="HTTP/1.1 200 OK"
    else
        # JQ 解析失败 (可能 API 返回了非标准的 JSON)
        HTTP_BODY='{"error": "JSON parsing failed after successful curl"}'
        STATUS_LINE="HTTP/1.1 500 Internal Server Error"
    fi
else
    # curl 失败或返回非 JSON (例如，网络错误、连接拒绝、或主程序仍在启动)
    # 保持 503 状态
    HTTP_BODY='{"error": "Service unavailable or connection failed", "curl_exit_code": '$CURL_EXIT_CODE'}'
fi

# 构造完整的 HTTP 响应头
printf "%s\r\n" "$STATUS_LINE"
printf "Content-Type: %s\r\n" "$CONTENT_TYPE"
printf "Connection: close\r\n"
printf "Content-Length: %d\r\n" "${#HTTP_BODY}"
printf "\r\n"

# 输出 Body
printf "%s" "$HTTP_BODY"

exit 0