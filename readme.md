# jesse's super simple .env file handler

if you don't like setting your env variables in your rc files, you can use this.

in the root of your nvim config, create a .env file and add your environment variables.

if no .env file is found, this plugin will throw early.

## lazy config

```lua
return {
    {
        "jesses-code-adventures/dotenv.nvim",
        config = function()
            require("dotenv").setup()
        end,
        lazy=false
    }
}
```

you may wish to provide a custom .env file path - you can use the env_path option to do this.

```lua
return {
    {
        "jesses-code-adventures/dotenv.nvim",
        config = function()
            require("dotenv").setup({
                env_path="~/.config/nvim/.custom_env_file" -- this could be any file path
            })
        end,
        lazy=false
    }
}
```

you can verify your variables are now available by echoing them as a neovim cmd.

```vim
:echo $MY_ENV_VAR
```

## formatting

if your .env file is incorrectly formatted, this plugin will throw early.

for example, this file will not work.

```
OPENAI_API_KEY=asdf=asdflj;
```

nor will this file.

```
OPENAI_API_KEY
```

## contributing

please feel free to make any pull requests you'd like to. this currently works how i need it to work but i'm open to any ideas.
