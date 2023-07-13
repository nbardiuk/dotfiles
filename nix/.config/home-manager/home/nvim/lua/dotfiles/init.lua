-- [nfnl] Compiled from fnl/dotfiles/init.fnl by https://github.com/Olical/nfnl, do not edit.
local autopairs = require("nvim-autopairs")
local Comment = require("Comment")
local c = require("aniseed.core")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local dressing = require("dressing")
local fidget = require("fidget")
local lightspeed = require("lightspeed")
local lspconfig = require("lspconfig")
local lspconfigs = require("lspconfig.configs")
local lspkind = require("lspkind")
local lualine = require("lualine")
local luasnip = require("luasnip")
local nu = require("aniseed.nvim.util")
local null_ls = require("null-ls")
local null_ls_helpers = require("null-ls.helpers")
local null_ls_methods = require("null-ls.methods")
local oil = require("oil")
local surround = require("nvim-surround")
local tel = require("telescope.builtin")
local telescope = require("telescope")
local themes = require("telescope.themes")
local tree_context = require("treesitter-context")
local tree_conf = require("nvim-treesitter.configs")
local tree_parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")
local other = require("other-nvim")
tree_context.setup({enable = true, separator = "\194\183"})
tree_conf.setup({indent = {enable = true}, highlight = {enable = true}, textobjects = {select = {enable = true, lookahead = true, keymaps = {aa = "@parameter.outer", ia = "@parameter.inner", ac = "@comment.outer", as = "@statement.outer"}}, swap = {enable = true, swap_next = {[">a"] = "@parameter.inner"}, swap_previous = {["<lt>a"] = "@parameter.inner"}}}, matchup = {enable = true}, auto_install = false})
vim.g.mapleader = " "
vim.g.maplocalleader = "\9"
local function indexed__3enamed(keys, tbl)
  for index = #tbl, 1, -1 do
    local key = tbl[index]
    local _1_ = keys[key]
    if (nil ~= _1_) then
      local value = _1_
      table.remove(tbl, index)
      do end (tbl)[key] = value
    else
    end
  end
  return tbl
end
local function keymap(m, args)
  local options = {buffer = true, silent = true, remap = true, noremap = true}
  local args0 = indexed__3enamed(options, args)
  local lhs = (args0)[1]
  local rhs = (args0)[2]
  local opts = c["select-keys"](args0, c.keys(options))
  return vim.keymap.set(m, lhs, rhs, opts)
end
local function nmap(...)
  return keymap("n", {"remap", ...})
end
local function nnoremap(...)
  return keymap("n", {"noremap", ...})
end
local function omap(...)
  return keymap("o", {"remap", ...})
end
local function tnoremap(...)
  return keymap("t", {"noremap", ...})
end
local function vnoremap(...)
  return keymap("v", {"noremap", ...})
end
local function xmap(...)
  return keymap("x", {"remap", ...})
end
local function xnoremap(...)
  return keymap("x", {"noremap", ...})
end
local bottom_height = 15
telescope.setup({defaults = themes.get_ivy({layout_config = {height = bottom_height}, preview = false}), extensions = {fzf = {fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case"}}})
telescope.load_extension("fzf")
nnoremap("<Leader>r", tel.resume)
nnoremap("<Leader>k", tel.help_tags)
nnoremap("<Leader><Leader>", tel.commands)
local function _3_()
  return tel.find_files({find_command = {"fd", "--hidden", "--exclude", ".git"}})
end
nnoremap("<Leader>n", _3_)
local function _4_()
  return tel.buffers({sort_lastused = true, ignore_current_buffer = false})
end
nnoremap("<Leader>e", _4_)
dressing.setup({select = {telescope = themes.get_ivy({layout_config = {height = bottom_height}})}})
local function _5_()
  return vim.api.nvim_list_bufs()
end
local _6_
do
  local tbl_14_auto = {}
  for k in pairs(lspkind.presets.default) do
    local k_15_auto, v_16_auto = k, ""
    if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
      tbl_14_auto[k_15_auto] = v_16_auto
    else
    end
  end
  _6_ = tbl_14_auto
end
local function _8_(_241)
  return luasnip.lsp_expand((_241).body)
end
local function _9_(_241)
  if cmp.visible() then
    return cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    return luasnip.expand_or_jump()
  else
    return _241()
  end
end
local function _11_(_241)
  if cmp.visible() then
    return cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    return luasnip.jump(-1)
  else
    return _241()
  end
end
cmp.setup({sources = {{name = "nvim_lsp"}, {name = "conjure"}, {name = "treesitter"}, {name = "vim-dadbod-completion"}, {name = "lausnip"}, {name = "path"}, {name = "buffer", keyword_length = 5, options = {get_bufnrs = _5_}}, {name = "spell", keyword_length = 5}}, formatting = {format = lspkind.cmp_format({mode = "symbol_text", symbol_map = _6_, menu = {nvim_lsp = "[lsp]", conjure = "[conj]", ["vim-dadbod-completion"] = "[db]", treesitter = "[tree]", luasnip = "[snip]", path = "[path]", buffer = "[buf]", spell = "[spell]"}})}, snippet = {expand = _8_}, mapping = {["<C-n>"] = cmp.mapping(_9_, {"i", "s"}), ["<C-p>"] = cmp.mapping(_11_, {"i", "s"}), ["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-u>"] = cmp.mapping.scroll_docs(4), ["<C-e>"] = cmp.mapping.close(), ["<Space>"] = cmp.mapping.confirm()}})
local lsp_capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities(), {workspace = {workspaceEdit = {documentChanges = true}}})
surround.setup({})
vim.opt.completeopt = {"menu", "menuone", "noselect"}
do end (vim.opt.complete):remove("t")
do end (vim.opt.shortmess):append("c")
do end (vim.opt.shortmess):append("I")
do end (vim.opt.shortmess):append("W")
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.startofline = false
vim.opt.guicursor = "a:blinkon0"
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"
vim.opt.clipboard = "unnamedplus"
local function _13_()
  do
    vim.highlight.on_yank({higroup = "Visual"})
  end
  return nil
end
vim.api.nvim_create_autocmd("TextYankPost", {callback = _13_, group = vim.api.nvim_create_augroup("yank", {clear = true}), pattern = "*"})
vim.opt.virtualedit = "block"
do end (vim.opt.matchpairs):append("<:>")
vim.opt.joinspaces = false
vim.opt.signcolumn = "yes:1"
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.colorcolumn = {100}
vim.opt.spelllang = "en_us"
vim.opt.spell = false
do end (vim.opt.spellsuggest):append(("" .. bottom_height))
nnoremap("silent", "]s", "<Cmd>execute ':setlocal spell'| normal! ]s<CR>")
nnoremap("silent", "]S", "<Cmd>execute ':setlocal spell'| normal! ]S<CR>")
nnoremap("silent", "[s", "<Cmd>execute ':setlocal spell'| normal! [s<CR>")
nnoremap("silent", "[S", "<Cmd>execute ':setlocal spell'| normal! [S<CR>")
vim.opt.wildmode = {"list:longest", "full"}
vim.opt.wildignorecase = true
vim.opt.list = true
vim.opt.listchars = {trail = "\194\183", tab = "\226\150\184 ", nbsp = "+"}
vim.opt.showbreak = "\226\134\179 "
vim.opt.shell = "/usr/bin/env zsh"
local function _14_()
  do
    vim.cmd.wincmd("=")
  end
  return nil
end
vim.api.nvim_create_autocmd("VimResized", {callback = _14_, group = vim.api.nvim_create_augroup("autoresize", {clear = true}), pattern = "*"})
vim.opt.winwidth = 80
vim.opt.winminwidth = 8
vim.opt.winheight = 24
vim.opt.winminheight = 2
vim.opt.splitright = true
vim.opt.splitbelow = true
nnoremap("<Leader>x", "<Cmd>bd!<CR>")
nnoremap("<Leader>X", "<Cmd>%bd!<CR>")
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.formatoptions = ("c" .. "j" .. "l" .. "n" .. "o" .. "q" .. "r")
vim.opt.background = "light"
vim.opt.termguicolors = true
do
  vim.cmd("colorscheme grey")
  do
    local to_clear = {"Identifier", "Function", "Statement", "Conditional", "Repeat", "Label", "Operator", "Exception", "PreProc", "Include", "Define", "Macro", "PreCondit", "Type", "StorageClass", "Structure", "Typedef", "Special", "Tag"}
    for _, group in pairs(to_clear) do
      vim.cmd(("highlight clear " .. group))
    end
  end
  local to_link = {Delimiter = "NonText", Comment = "Directory", Whitespace = "VertSplit", TermCursorNC = "Cursor", Boolean = "Yellow", ["@symbol"] = "Keyword", ["@lsp.type.namespace"] = "@namespace", ["@lsp.type.type"] = "@type", ["@lsp.type.class"] = "@type", ["@lsp.type.enum"] = "@type", ["@lsp.type.interface"] = "@type", ["@lsp.type.struct"] = "@structure", ["@lsp.type.parameter"] = "@parameter", ["@lsp.type.variable"] = "@variable", ["@lsp.type.property"] = "@property", ["@lsp.type.enumMember"] = "@constant", ["@lsp.type.function"] = "@function", ["@lsp.type.method"] = "@method", ["@lsp.type.macro"] = "@macro", ["@lsp.type.decorator"] = "@function", OilDir = "Directory", OilLink = "Yellow"}
  for src, dest in pairs(to_link) do
    vim.api.nvim_set_hl(0, src, {link = dest, default = false})
  end
end
vim.opt.ruler = false
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.title = true
vim.opt.titlestring = "%f"
vim.opt.winbar = "%f"
lualine.setup({options = {globalstatus = true, icons_enabled = false}})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 999
vim.opt.fillchars = "fold:\226\128\167"
nnoremap("<BS>", "za")
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.inccommand = "nosplit"
vim.opt.gdefault = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
nnoremap("n", "nzz")
nnoremap("N", "Nzz")
vnoremap("/", "y/\\V<C-r>\"<CR>")
nnoremap("/", "/\\v")
nnoremap("<Leader>f", tel.live_grep)
nnoremap("<Leader>q", tel.quickfix)
vim.g.FerretMaxResults = 10000
vim.g.FerretQFHandler = ("botright copen " .. bottom_height)
vim.g.FerretExecutable = "rg"
vim.g.FerretExecutableArguments = {rg = (" --vimgrep" .. " --no-heading" .. " --smart-case" .. " --sort path" .. " --hidden" .. " --glob=!.git")}
vim.g.FerretMap = false
nmap("<Leader>*", "<Plug>(FerretAckWord)")
vnoremap("<Leader>*", "y:Ack <C-r>\"<CR>")
nmap("<Leader>/", "<Plug>(FerretAck)")
vnoremap("<Leader>/", "y:Ack <C-r>\"")
vim.opt.path = {".", "**"}
Comment.setup({})
lightspeed.setup({ignore_case = true})
oil.setup({columns = {{"permissions", highlight = "NonText"}, {"size", highlight = "String"}, {"ctime", highlight = "Number", format = "%Y-%m-%d %H:%M"}}, view_options = {show_hidden = true}, keymaps = {["g?"] = "actions.show_help", ["<CR>"] = "actions.select", ["<C-s>"] = "actions.select_vsplit", ["<C-r>"] = "actions.refresh", ["<C-p>"] = "actions.preview", ["<C-c>"] = "actions.close", ["-"] = "actions.parent", _ = "actions.open_cwd", ["g."] = "actions.toggle_hidden", ["."] = "actions.open_cmdline", [","] = "actions.open_cmdline_dir", gy = "actions.copy_entry_path"}, use_default_keymaps = false})
nmap("-", oil.open)
vim.opt.updatetime = 100
do end (vim.opt.diffopt):append({"indent-heuristic", "internal", "algorithm:histogram", "linematch:60"})
vim.g.gitgutter_map_keys = false
nnoremap("silent", "<Leader>gd", "<Cmd>Gdiffsplit<CR>")
nnoremap("silent", "<Leader>gs", "<Cmd>Git|only<CR>")
nnoremap("silent", "<Leader>gl", "<Cmd>Gclog<CR>")
nmap("<Leader>hp", "<Plug>(GitGutterPreviewHunk)")
nmap("<Leader>hs", "<Plug>(GitGutterStageHunk)")
nmap("<Leader>hu", "<Plug>(GitGutterUndoHunk)")
nmap("[h", "<Plug>(GitGutterPrevHunk)")
nmap("]h", "<Plug>(GitGutterNextHunk)")
omap("ih", "<Plug>(GitGutterTextObjectInnerPending)")
xmap("ih", "<Plug>(GitGutterTextObjectInnerVisual)")
omap("ah", "<Plug>(GitGutterTextObjectOuterPending)")
xmap("ah", "<Plug>(GitGutterTextObjectOuterVisual)")
nnoremap("yoh", "<Cmd>GitGutterSignsToggle<CR>")
local function _15_()
  if vim.tbl_contains((vim.opt.diffopt):get(), "iwhite") then
    do end (vim.opt.diffopt):remove("iwhite")
    return vim.notify("noiwhite")
  else
    do end (vim.opt.diffopt):append("iwhite")
    return vim.notify("iwhite")
  end
end
nnoremap("<Leader>dw", _15_)
local function _17_()
  do
    vim.opt_local.spell = true
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _17_, group = vim.api.nvim_create_augroup("gitcommit", {clear = true}), pattern = "gitcommit"})
vim.g.fugitive_summary_format = "%ah %d %s"
vim.g.wiki_root = "~/Notes"
vim.g.wiki_mappings_global = {["<Plug>(wiki-open)"] = "<Leader>we"}
vim.g.wiki_mappings_local = {["<Plug>(wiki-journal-copy-tonext)"] = "", ["<Plug>(wiki-link-next)"] = "", ["<Plug>(wiki-link-return)"] = "", ["<Plug>(wiki-link-toggle)"] = "", ["<Plug>(wiki-page-toc)"] = ""}
local function _18_()
  return tel.find_files({cwd = vim.g.wiki_root})
end
nnoremap("<Leader>wn", _18_)
local function _19_()
  return tel.live_grep({cwd = vim.g.wiki_root})
end
nnoremap("<Leader>wf", _19_)
null_ls.setup({sources = {null_ls.builtins.code_actions.statix, null_ls.builtins.diagnostics.vale.with({filetypes = {"markdown", "gitcommit"}}), null_ls.builtins.diagnostics.statix, null_ls.builtins.diagnostics.shellcheck, null_ls.builtins.diagnostics.hadolint, null_ls.builtins.diagnostics.codespell, null_ls.builtins.diagnostics.yamllint.with({extra_args = {"--config-data", ("{ extends: default," .. "rules: { line-length: {max: 120}," .. "document-start: {present: false}}}")}}), null_ls.builtins.formatting.zprint, null_ls.builtins.formatting.fixjson, null_ls.builtins.formatting.prettier, null_ls.builtins.formatting.nixpkgs_fmt, null_ls.builtins.formatting.xmllint, null_ls.builtins.formatting.trim_whitespace.with({filetypes = {"yaml", "docker", "fennel"}}), null_ls.builtins.formatting.clang_format.with({filetypes = {"glsl"}}), null_ls.builtins.formatting.shfmt.with({extra_args = {"-i", "2", "-sr"}}), null_ls.builtins.formatting.pg_format.with({extra_args = {"--spaces", "2", "--comma-break", "--function-case", "2", "--placeholder", "\\?[a-zA-Z]+\\?", "-"}})}})
local function enabled_formatting_3f(client)
  local disabled_formatters = {"tsserver", "clojure_lsp"}
  return not vim.tbl_contains(disabled_formatters, client.name)
end
local function _20_()
  return vim.lsp.buf.format({timeout_ms = 5000, filter = enabled_formatting_3f})
end
nnoremap("<Leader>lf", _20_)
nnoremap("<Leader>la", vim.lsp.buf.code_action)
local function lsp_buffer_mappings()
  nnoremap("buffer", "gd", vim.lsp.buf.definition)
  nnoremap("buffer", "<Leader>lt", vim.lsp.buf.type_definition)
  nnoremap("buffer", "}", vim.lsp.buf.references)
  nnoremap("buffer", "<Leader>lr", vim.lsp.buf.rename)
  return nnoremap("buffer", "K", vim.lsp.buf.hover)
end
vim.diagnostic.config({underline = true, float = {show_header = false}, severity_sort = true, signs = true, virtual_text = false})
local function _21_()
  return vim.diagnostic.open_float(nil, {scope = "line", border = "single"})
end
nnoremap("L", _21_)
local function _22_()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
  return vim.notify(("diagnostic disabled? " .. tostring(vim.diagnostic.is_disabled())))
end
nnoremap("yol", _22_)
nnoremap("]d", vim.diagnostic.goto_next)
nnoremap("[d", vim.diagnostic.goto_prev)
do end (vim.lsp.handlers)["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "single"})
do end (vim.lsp.handlers)["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.singature_help, {border = "single"})
fidget.setup({})
vim.g["conjure#eval#result_register"] = "e"
vim.g["conjure#log#botright"] = true
local function _24_()
  do
    vim.diagnostic.disable(0)
  end
  return nil
end
vim.api.nvim_create_autocmd("BufNewFile", {callback = _24_, group = vim.api.nvim_create_augroup("conjure-log", {clear = true}), pattern = "conjure-log-*"})
vim.g["conjure#filetypes"] = {"clojure", "fennel", "python"}
vim.g["conjure#eval#gsubs"] = {["do-comment"] = {"^%(comment[%s%c]", "(do "}}
vim.g["conjure#mapping#doc_word"] = "k"
local function _25_()
  do
    lsp_buffer_mappings()
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _25_, group = vim.api.nvim_create_augroup("python", {clear = true}), pattern = "python"})
lspconfig.pylsp.setup({capabilities = lsp_capabilities})
local function _26_()
  do
    lsp_buffer_mappings()
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _26_, group = vim.api.nvim_create_augroup("typescript", {clear = true}), pattern = {"typescript", "javascript", "typescriptreact", "javascriptreact"}})
local function _28_(...)
  local _let_27_ = vim.fn.systemlist("realpath `which tsserver`")
  local tsserver_bin = _let_27_[1]
  local tsserver_path = string.gsub(tsserver_bin, "bin/tsserver", "lib")
  return tsserver_path
end
lspconfig.tsserver.setup({capabilities = lsp_capabilities, cmd = {"typescript-language-server", "--stdio", "--tsserver-path", _28_(...)}})
local function _29_()
  do
    lsp_buffer_mappings()
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _29_, group = vim.api.nvim_create_augroup("rust", {clear = true}), pattern = "rust"})
lspconfig.rust_analyzer.setup({capabilities = lsp_capabilities})
local function _30_()
  do
    lsp_buffer_mappings()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _30_, group = vim.api.nvim_create_augroup("c", {clear = true}), pattern = {"c", "cpp"}})
lspconfig.ccls.setup({capabilities = lsp_capabilities})
vim.g.sexp_filetypes = "clojure,scheme,lisp,fennel"
local function _31_()
  do
    xmap("buffer", "ip", "<Plug>(sexp_inner_element)<Plug>(sexp_move_to_next_element_tail)")
    omap("buffer", "ip", "<Cmd>normal vip<CR>")
    xmap("buffer", "iP", "<Plug>(sexp_inner_element)o<Plug>(sexp_move_to_prev_element_head)")
    omap("buffer", "iP", "<Cmd>normal viP<CR>")
    nmap("buffer", ">p", "vip>eo<Esc>")
    nmap("buffer", "<p", "vip<eo<Esc>")
    xmap("buffer", ">e", "<Plug>(sexp_swap_element_forward)")
    xmap("buffer", "<e", "<Plug>(sexp_swap_element_backward)")
    xmap("buffer", ">f", "<Plug>(sexp_swap_list_forward)")
    xmap("buffer", "<f", "<Plug>(sexp_swap_list_backward)")
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _31_, group = vim.api.nvim_create_augroup("sexp", {clear = true}), pattern = {"clojure", "scheme", "lisp", "fennel"}})
vim.g.sexp_enable_insert_mode_mappings = false
autopairs.setup({disable_in_visualblock = true, enable_check_bracket_line = false})
local function clj_ignore()
  nu.normal("`[")
  return nu.normal("i#_")
end
local function do_clj_ignore(form)
  vim.opt.operatorfunc = ("v:lua.require'" .. __fnl_global___2amodule_2dname_2a .. "'.clj_ignore")
  return vim.api.nvim_feedkeys(("g@" .. (form or "")), "m", false)
end
local function conjure_eval(form)
  return vim.cmd.ConjureEval(form)
end
local function _32_()
  do
    lsp_buffer_mappings()
    xnoremap("buffer", "<Leader>cc", do_clj_ignore)
    nnoremap("buffer", "<Leader>cc", do_clj_ignore)
    nnoremap("buffer", "<Leader>cu", "<Cmd>let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")
    local function _33_()
      return vim.lsp.buf.execute_command({command = "move-form", arguments = {("file://" .. vim.fn.expand("%:p")), (vim.fn.line(".") - 1), (vim.fn.col(".") - 1), vim.fn.input("File: ", vim.fn.expand("%:p:h"), "file")}})
    end
    nnoremap("buffer", "<Leader>lm", _33_)
    local function _34_()
      return conjure_eval("((requiring-resolve 'portal.api/open))")
    end
    nnoremap("buffer", "<LocalLeader>po", _34_)
    local function _35_()
      return conjure_eval("((requiring-resolve 'portal.api/close))")
    end
    nnoremap("buffer", "<LocalLeader>pc", _35_)
    local function _36_()
      return conjure_eval("((requiring-resolve 'portal.api/clear))")
    end
    nnoremap("buffer", "<LocalLeader>pr", _36_)
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.includeexpr = "substitute(substitute(v:fname,'\\.','/','g'),'-','_','g')"
    vim.opt_local.suffixesadd = ".clj"
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _32_, group = vim.api.nvim_create_augroup("clojure", {clear = true}), pattern = "clojure"})
vim.g["conjure#client#clojure#nrepl#test#runner"] = "clojure"
vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
lspconfig.clojure_lsp.setup({capabilities = lsp_capabilities})
vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = true
vim.g.slime_default_config = {socket_name = "default", target_pane = "{right-of}"}
vim.g.slime_no_mappings = true
xmap("<Leader>s", "<Plug>SlimeRegionSend")
nmap("<Leader>s", "<Plug>SlimeMotionSend")
nmap("<Leader>ss", "<Plug>SlimeLineSend")
nmap("<Leader>sc", "<Plug>SlimeConfig")
xnoremap("<Leader>sy", "\"sy")
nnoremap("<Leader>sp", "<Cmd>SlimeSend1 <C-R>s<CR>")
local function scm_ignore()
  nu.normal("`[")
  return nu.normal("i#;")
end
local function do_scm_ignore(form)
  vim.opt.operatorfunc = ("v:lua.require'" .. __fnl_global___2amodule_2dname_2a .. "'.scm_ignore")
  return vim.api.nvim_feedkeys(("g@" .. (form or "")), "m", false)
end
local function _37_()
  do
    xnoremap("buffer", "<Leader>c", do_scm_ignore)
    local function _38_()
      return do_scm_ignore("aF")
    end
    nnoremap("buffer", "<Leader>cc", _38_)
    nmap("buffer", "<Leader>cu", "<Cmd>let s=@/<CR>l?\11(#;)+<CR>dgn:let @/=s<CR>")
    nmap("buffer", "<Leader>pp", "<Plug>SlimeMotionSend<Plug>(sexp_outer_top_list)``")
    nnoremap("buffer", "K", "<Cmd>SlimeSend1 (pp <C-R><C-W>)<CR>")
    nmap("buffer", "<Leader>lf", "ggvG=``")
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _37_, group = vim.api.nvim_create_augroup("scheme", {clear = true}), pattern = "scheme"})
vim.g.vrc_curl_opts = {["--connect-timeout"] = 10, ["--include"] = "", ["--location"] = "", ["--max-time"] = 60, ["--show-error"] = "", ["--silent"] = ""}
vim.g.vrc_auto_format_response_patterns = {json = "jq", xml = "grep \"\\S\" | xmllint --format --nonet --recover -"}
local function _39_()
  do
    local function _40_()
      vim.b.vrc_debug = not vim.b.vrc_debug
      vim.b.vrc_show_command = vim.b.vrc_debug
      local function _41_()
        if vim.b.vrc_debug then
          return "debug"
        else
          return "nodebug"
        end
      end
      return vim.notify(_41_())
    end
    nnoremap("buffer", "<Leader>cd", _40_)
    local function _42_()
      vim.b.vrc_allow_get_request_body = not vim.b.vrc_allow_get_request_body
      local function _43_()
        if vim.b.vrc_allow_get_request_body then
          return "allow body"
        else
          return "disallow body"
        end
      end
      return vim.notify(_43_())
    end
    nnoremap("buffer", "<Leader>cb", _42_)
    local function _44_()
      vim.b.vrc_split_request_body = not vim.b.vrc_split_request_body
      local function _45_()
        if vim.b.vrc_split_request_body then
          return "split"
        else
          return "nosplit"
        end
      end
      return vim.notify(_45_())
    end
    nnoremap("buffer", "<Leader>cs", _44_)
    local function _46_()
      vim.b.vrc_output_buffer_name = ("[" .. vim.fn.expand("%:t") .. "@" .. vim.fn.strftime("%H:%M:%S") .. "]" .. string.gsub(vim.api.nvim_get_current_line(), "\"", "\\\""))
      return vim.fn.VrcQuery()
    end
    nnoremap("buffer", "<Leader>cc", _46_)
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _39_, group = vim.api.nvim_create_augroup("rest", {clear = true}), pattern = "rest"})
local function _47_()
  do
    vnoremap("buffer", "<Leader>tj", ":!pandoc -f gfm -t jira<CR>")
  end
  return nil
end
vim.api.nvim_create_autocmd("FileType", {callback = _47_, group = vim.api.nvim_create_augroup("markdown", {clear = true}), pattern = "markdown"})
vim.g.markdown_syntax_conceal = false
vim.g.markdown_folding = 1
local function _48_()
  do
    vim.opt_local.filetype = "glsl"
  end
  return nil
end
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {callback = _48_, group = vim.api.nvim_create_augroup("glsl-detect", {clear = true}), pattern = {"*.glsl", "*.vert", "*.geom", "*.frag"}})
nnoremap("<Leader>aa", "<Cmd>Other<CR>")
nnoremap("<Leader>av", "<Cmd>OtherVSplit<CR>")
other.setup({mappings = {{pattern = "(.*)/src/(.*).clj", target = "%1/test/%2_test.clj"}, {pattern = "(.*)/test/(.*)_test.clj", target = "%1/src/%2.clj"}}})
tnoremap("<Esc>", "<C-\\><C-n>")
tnoremap("<C-v><Esc>", "<Esc>")
local function _49_()
  do
    vim.opt_local.winbar = "%{b:term_title}"
    vim.opt_local.bufhidden = "hide"
  end
  return nil
end
vim.api.nvim_create_autocmd("TermOpen", {callback = _49_, group = vim.api.nvim_create_augroup("terminal-open", {clear = true}), pattern = "*"})
local function _50_()
  do
    if (vim.b.terminal_job_pid and vim.b.term_title) then
      vim.cmd.file(("term:" .. vim.b.terminal_job_pid .. ":" .. vim.b.term_title))
    else
    end
  end
  return nil
end
vim.api.nvim_create_autocmd("TermLeave", {callback = _50_, group = vim.api.nvim_create_augroup("terminal-leave", {clear = true}), pattern = "*"})
local function _54_(_52_)
  local _arg_53_ = _52_
  local path = _arg_53_["args"]
  local path0
  if (path == "") then
    path0 = "%:h"
  else
    path0 = path
  end
  vim.cmd(table.concat({"vsplit", ("lcd " .. path0), "terminal"}, "|"))
  return vim.api.nvim_feedkeys("i", "n", false)
end
vim.api.nvim_create_user_command("Term", _54_, {nargs = "?", desc = "Open terminal"})
local function _58_(_56_)
  local _arg_57_ = _56_
  local suffix = _arg_57_["args"]
  return vim.cmd.edit((vim.fn.tempname() .. "_" .. suffix))
end
vim.api.nvim_create_user_command("Scratch", _58_, {nargs = "?", desc = "New temporary file"})
local function _59_()
  do
    vim.cmd("silent! update")
  end
  return nil
end
vim.api.nvim_create_autocmd({"FocusLost", "BufLeave", "CursorHold"}, {callback = _59_, group = vim.api.nvim_create_augroup("autosave", {clear = true}), pattern = {"*"}})
local function _60_()
  do
    vim.cmd("silent! checktime")
  end
  return nil
end
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold"}, {callback = _60_, group = vim.api.nvim_create_augroup("autoread", {clear = true}), pattern = {"*"}})
local function _61_()
  do
    local _let_62_ = vim.api.nvim_buf_get_mark(0, "\"")
    local line = _let_62_[1]
    local col = _let_62_[2]
    local line_count = vim.api.nvim_buf_line_count(0)
    if ((1 <= line) and (line <= line_count) and ((vim.opt.ft):get() ~= "commit")) then
      vim.api.nvim_win_set_cursor(0, {line, col})
    else
    end
  end
  return nil
end
vim.api.nvim_create_autocmd("BufReadPost", {callback = _61_, group = vim.api.nvim_create_augroup("jump-to-last-postion", {clear = true}), pattern = "*"})
nmap("ga", "<Plug>(EasyAlign)")
return xmap("ga", "<Plug>(EasyAlign)")
