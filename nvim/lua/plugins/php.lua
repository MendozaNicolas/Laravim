return {
  -- LSP para PHP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              stubs = {
                "bcmath", "bz2", "calendar", "Core", "curl", "date",
                "dba", "dom", "enchant", "fileinfo", "filter", "ftp", "gd",
                "gettext", "hash", "iconv", "imap", "intl", "json", "ldap",
                "libxml", "mbstring", "mcrypt", "mysql", "mysqli", "password",
                "pcntl", "pcre", "PDO", "pdo_mysql", "Phar", "readline",
                "recode", "Reflection", "regex", "session", "SimpleXML", "soap",
                "sockets", "sodium", "SPL", "standard", "superglobals", "sysvsem",
                "sysvshm", "tokenizer", "xml", "xdebug", "xmlreader", "xmlwriter",
                "yaml", "zip", "zlib", "wordpress", "phpunit", "laravel"
              },
              files = {
                maxSize = 5000000,
              },
            },
          },
        },
        phpactor = {
          enabled = false, -- Usar solo Intelephense o ambos
        },
      },
    },
  },

  -- Laravel extras
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    keys = {
      { "<leader>la", ":Laravel artisan<cr>", desc = "Laravel Artisan" },
      { "<leader>lr", ":Laravel routes<cr>", desc = "Laravel Routes" },
      { "<leader>lm", ":Laravel related<cr>", desc = "Laravel Related" },
    },
    event = { "VeryLazy" },
    config = true,
  },

  -- Blade syntax
  {
    "jwalton512/vim-blade",
    ft = "blade",
  },
}
