(fn au [group event pattern ...]
  `(do
     (defn ,group [] ,...)
     (vim.schedule
       #(vim.cmd
          (.. "augroup " ,(tostring group) "
              autocmd!
              autocmd " ,(tostring event) " " ,(tostring pattern) " lua require('" *module-name* "')['" ,(tostring group) "']()
              augroup END")))))

{:au au}
