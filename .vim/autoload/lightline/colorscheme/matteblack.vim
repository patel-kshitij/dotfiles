" Matte Black statusline colors for lightline
let s:fg1 = ['#EAEAEA', 255] | let s:fg3 = ['#8A8A8D', 245]
let s:bg1 = ['#121212', 233] | let s:bg2 = ['#333333', 236] | let s:bg3 = ['#212121', 234]
let s:orange = ['#F59E0B', 214] | let s:teal = ['#10B981', 36]
let s:blue = ['#3B82F6', 69] | let s:crimson = ['#DC2626', 160] | let s:gold = ['#EFBF04', 220]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [[s:bg1, s:orange, 'bold'], [s:fg1, s:bg2]]
let s:p.normal.middle = [[s:fg3, s:bg3]]
let s:p.normal.right = [[s:fg1, s:bg2], [s:fg3, s:bg3]]
let s:p.normal.error = [[s:bg1, s:crimson]]
let s:p.normal.warning = [[s:bg1, s:gold]]
let s:p.insert.left = [[s:bg1, s:teal, 'bold'], [s:fg1, s:bg2]]
let s:p.visual.left = [[s:bg1, s:blue, 'bold'], [s:fg1, s:bg2]]
let s:p.replace.left = [[s:bg1, s:crimson, 'bold'], [s:fg1, s:bg2]]
let s:p.inactive.left = [[s:fg3, s:bg3], [s:fg3, s:bg3]]
let s:p.inactive.middle = [[s:fg3, s:bg1]]
let s:p.inactive.right = [[s:fg3, s:bg3], [s:fg3, s:bg3]]
let s:p.tabline.left = [[s:fg3, s:bg2]]
let s:p.tabline.tabsel = [[s:bg1, s:orange, 'bold']]
let s:p.tabline.middle = [[s:fg3, s:bg1]]
let s:p.tabline.right = [[s:fg1, s:bg2]]

let g:lightline#colorscheme#matteblack#palette = lightline#colorscheme#flatten(s:p)
