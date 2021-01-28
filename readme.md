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

  * update_command
    * This basically does what trying to add a picture to an existing command with add_command, so it's an alias for it but it only updates commands.

  * delete_command
    * This deletes a given command, here's how you would use it:
    ```
      !delete_command stick
    ```

      It returns a confirmation message.

  * list_contents
    * This command sends back a list with the contents of a given command in the order they were added with a 0-based index. The contents are wrapped between < > to avoid links from previewing.

  * remove_item
    * This command is used to remove an item in a command by its position with a 0-based index.

  * change_avatar
    * This command is used to change the bot's avatar providing an URL with the avatar desired. Only the user designated as the admin/owner of the bot can use this command.

  * playing
    * This command changes the "playing" status of the bot but providing a string after the command. Only the user designated as the admin/owner of the bot can use this command.

* Raid making commands
  * create raid_name (or alias)
    * Creates a raid. Example: !create apollo
    * Creates a raid using an alias, like Dark Angel Olivia: !create dao. This will generate a 3 letter code used to join.
  * join raid_code class
    * Joins a raid as a certain class, EX skills are optional. Example: !join AGF DF(AR3)
  * leave raid_code
    * leaves a raid. Example: !leave AGF
* check raid_code (optional)
  * Check a raid status (members joined and their roles and suggested roles) if given a raid name, otherwise it'll list all the raids and how many people joined.
    * Example: !check AGF
      Raid: Apollo by admin (1/6)
        Members joined:
          admin as HE(TH3)
    * Example: !check
      * Raid: Apollo (AGF) - Joined: 1/6
      * Raid: Rose Queen  (BVC)- Joined: 0/6
* finsh ends a the raid the user created and sends a otsu sticker.

All these commmands work with aliases.

* Filter: whenever someone sends a message with "dumb clarise" (or a lot of variations like clarice, clarrise, etc), the bot will send a clarise picture.


## How to use

  If you want to use this bot, you'll need to install all the depedencies for [discordrb](https://github.com/meew0/discordrb).

  Once you're done, go [here](https://discordapp.com/developers/applications/me) to create a discord app/bot account and write down the token and application ID, then open example.env, replace the example values in TOKEN, APPID and ADMINID (this is the number after the pound sign (#) when you click on your name in discord, example: admin#xxxx, where xxxx is the ID we're looking for) then rename the file to just ".env" and place is in the root directory.

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
  * Find a way to fetch the lastest news and make the bot check for news in intervals on a given day.
