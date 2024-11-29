# jesse's super simple .env file handler

if you don't like setting your env variables in your rc files, you can use this.

in the root of your nvim config, create a .env file and add your environment variables.

## lazy config

```lua
return {
    {
        "jesses-code-adventures/dotenv.nvim",
        lazy=false
    }
}
```

you may wish to provide a custom `env` filename, which you can do with the `overrides` option.

```lua
return {
    {
        "jesses-code-adventures/dotenv.nvim",
        opts={
            overrides={".env_custom"} -- you could also do multiple, such as {".env", ".env.mine"} to override default `.env` vars with `.env.mine` vars.
        },
        lazy=false
    }
}
```

you can verify your variables are now available by echoing them as a neovim cmd.

```vim
:echo $MY_ENV_VAR
```

## contributing

please feel free to make any pull requests you'd like to. this currently works how i need it to work but i'm open to any ideas.
