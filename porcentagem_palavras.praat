# Escola de Estudos Linguísticos do GEL - 2020
# Curso "Iniciação à Fonética Forense"
# ============================================
#
# Relatório de segmentação em ruído: porcentagem de 
# palavras transcritas por nível de ruído
#
# criado em: 2013-09-09
# modificado em: 2020-11-25
#
# Pablo Arantes <pabloarantes@protonmail.com>

# Instruções de uso:
# ------------------
# 1. O usuário deve fornecer um arquivo TextGrid contendo diferentes
# camadas (boundary tiers)
# 2. As camadas devem estar organizadas em ordem decrescente em relação
# ao nível de ruído, i.e., a camada 1 deve conter a segmentação do nível mais
# ruidoso, a camada 2 o nível de ruído imediatamente menor e assim
# por diante, até o nível em que não há mais ruído.

grid_name$ = chooseReadFile$("Selecione um arquivo TextGrid")
if grid_name$ <> ""
	grid = Read from file: grid_name$
endif
grid$ = selected$("TextGrid")
n = Get number of tiers
for i to n
	selectObject(grid)
	tier = Extract one tier: i
	table[i] = Down to Table: "no", 1, "yes", "no"
	nrows = Get number of rows
	nwords = 0
	# Process each interval in selected tier
	for j to nrows
		# Read text from TextGrid interval
		str_raw$ = Get value: j, "text"

		# Replace non-word characters by one blank space
		str_clean$ = replace_regex$(str_raw$, "[^a-zA-ZçÇãÃõÕáÁéÉíÍóÓúÚâÂôÔêÊüÜàÀ-]+", " ", 0)

		# Trim trailing and leading spaces
		str_clean$ = replace_regex$(str_clean$, "^\s+|\s+$", "", 0)
		len_clean = length(str_clean$)

		# Find number of word boundaries
		str_no_spaces$ = replace_regex$(str_clean$, " ", "", 0)
		len_no_spaces = length(str_no_spaces$)

		# Number of words
		words = (len_clean - len_no_spaces) + 1
		nwords = nwords + words
	endfor
	removeObject(tier, table[i])
	tier[i] = nwords
endfor

writeInfo: ""
writeInfoLine("Arquivo: ", grid$, newline$)
appendInfoLine("Porcentagem de palavras transcritas por nível de ruído (nível 0 é 100%)", newline$)
appendInfoLine("nivel", tab$, "n pal.", tab$, "% transcr.")
appendInfoLine("-----", tab$, "------", tab$, "----------")

for i to n
	appendInfoLine(n - i, tab$, tier[i], tab$, fixed$((tier[i] / tier[n]) * 100, 1))
endfor

