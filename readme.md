# Tsumugi Discord bot
A small discord bot using [discordrb](https://github.com/meew0/discordrb/).

## List of current commands and filters
The commands have a "!" prefix.
* stick (sends a picture of beatrix making fun of stick users)
* otsu (sends the ostukare sticker)
* police (sends a picture of the grandcypher police)
* Random pic commands
  * sen (sends a random Sen picture)
  * windmeme (sends a random windememe releated picture)
  * snek (sends a laughing snek, there's a rare chance to get a dagger!)
* Raid making commands
  * create [raid_name]
    * Creates a raid. Example: !create apollo
  * join [raid_name] [class]
    * Joins a raid as a certain class, EX skills are optional. Example: !join apollo DF(AR3)
  * leave [raid_name]
    * leaves a raid. Example: !leave apollo
* check [raid_name] (optional)
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
  * Increase the bucket size for picture triggers (and maybe removing the error messages when the bucket limit is reached).
  * Add user-made picture/link triggers.
  * Sort and load pictures from directories. Example: Having a directory for windmeme pictures so whenever !windeme is fired, it will send a picture from that directory instead of having the URLs hardcoded.
