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
  * create raid_name
    * Creates a raid. Example: !create apollo
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
* Filter: whenever someone sends a message with "dumb clarise" (or a lot of variations like clarice, clarrise, etc), the bot will send a clarise picture.

## TODO:
  * Twitter integration to fetch the Angel Halo hours.
  * Add alias to raids (Dark Angel Oliva is often called DAO o DAOlivia).
  * Limit the dumb clarise posting.
