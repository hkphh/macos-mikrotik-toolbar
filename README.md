# macos-toolbar-api
Any REST RouterOS requests in your MacOS toolbar widget

<img width="276" alt="image" src="https://github.com/user-attachments/assets/bc2f9e4a-b6c9-49a8-af2c-ba61523908b4">

## Benefits

- **Customizable Functionality**: Easily bring any functionality you frequently use to quick access.
- **Ease of Use**: Adding buttons and modifying the JSON body is straightforward (<a href="https://help.mikrotik.com/docs/display/ROS/REST+API">read RouterOS wiki</a>).


## Purpose

I implemented this functionality for myself with the following purposes:

- **Frequent Mangle Rule Management**: I often log into my router to enable or disable Mangle rules.
- **No MacOS Winbox App**: There is no native application for MacOS, so I have to run WinBox through Wine (I added an alias for launching it, but it's still less convenient).
- **Regular Address List Updates**: I regularly update the address-list with various domains so that requests to these domains are routed through other countries.


## How to use

> just press buttons :)


The example(pic) shows two buttons behind which two REST requests are hidden:
- POST -> http://\\(routerIp)/rest/ip/firewall/mangle/enable _with json: ["numbers": "5"]
- POST -> http://\\(routerIp)/rest/ip/firewall/mangle/disable _with json: ["numbers": "5"]

as well as an input field for a REST request:
- PUT http://(routerIp)/rest/ip/firewall/address-list _with json: ["address": "example.com", "list": "address-list-vpn"]

All of this is hidden in a convenient widget, allowing for quick interaction with your MikroTik.

Feedback Welcome: Use it to achieve any of your goals, and feel free to leave feedback.


