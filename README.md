# gt
Powershell fzf directory jumper

Installation: 
1. `winget install fzf`
2. Paste code into your powershell profile
3. Done

In windows terminal settings.json you can bind gt to a shortcut using a custom action:
```json
{
    "command": 
    {
        "action": "sendInput",
        "input": "gt\r"
    },
    "keys": "ctrl+p"
},
```
