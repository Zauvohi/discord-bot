# Tsumugi Discord bot
A small discord bot using [discordrb](https://github.com/meew0/discordrb/).

## List of current commands and filters
The commands have a "!" prefix.
* Custom commands
  * Custom commands pretty much replace the need for picture commands, here how you add a custom command:
    ```
      !add_command trigger type url
    ```
    An example would be:
    ```
      !add_command stick img url_to_picture
    ```

    This information is stored in a JSON file located in /commands

* Raid making commands
  * create raid_name (or alias)
    * Creates a raid. Example: !create apollo
    * Creates a raid using an alias, like Dark Angel Olivia: !create dao
  * join raid_name class
    * Joins a raid as a certain class, EX skills are optional. Example: !join apollo DF(AR3)
  * leave raid_name
    * leaves a raid. Example: !leave apollo
* check raid_name (optional)
  * Check a raid status (members joined and their roles and suggested roles) if given a raid name, otherwise it'll list all the raids and how many people joined.
    * Example: !check apollo
      * Raid: Apollo (1/6) Members joined: sied as HE(TH3) Roles suggested:
      * DF(AR3) SS(CHARM) HS(DI3) HS(BLIND) BS(CLEAR) BS(FREE)
    * Example: !check
      * Raid: Apollo - Joined: 1/6
      * Raid: Rose Queen - Joined: 0/6
* finsh ends a the raid the user created and sends a otsu sticker.

All these commmands work with aliases.

* Filter: whenever someone sends a message with "dumb clarise" (or a lot of variations like clarice, clarrise, etc), the bot will send a clarise picture.


## How to use

  If you want to use this bot, you'll need to install all the depedencies for [discordrb](https://github.com/meew0/discordrb).

  Once you're done, go [here](https://discordapp.com/developers/applications/me) to create a discord app/bot account and write down the token and application ID, then open example.env, replace the example values in TOKKEN and APPID and rename the file to just ".env".

  Then just run the bot like:
  ```
    ruby tsumugi_bot.rb
  ```

  To add the bot to your chat, you'll have to go to this URL adding your AppID:
  ```
    https://discordapp.com/oauth2/authorize?client_id=YOUR_APP_ID&scope=bot&permissions=0
  ```

  Congrats, your bot is ready to spam your chat with memes.

## TODO:
  * Twitter integration to fetch the Angel Halo hours.
  * Find a way to have separate instances of the bot on different chats without clashing with each other.
