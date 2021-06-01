(fn ft [group types ...]
  `(do
     (defn ,group [] ,...)
     (vim.schedule
       (fn []
         (vim.cmd
           (.. "augroup " ,(tostring group) "
               autocmd!
               autocmd FileType " ,(tostring types) " lua require('init')['" ,(tostring group) "']()
               augroup END"))))))

{:ft ft}
