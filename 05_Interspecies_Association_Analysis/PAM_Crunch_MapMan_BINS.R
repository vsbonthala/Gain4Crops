# URL: https://github.com/schneebergerlab/Scripts_supporting_Kiefer_Willing_et_al_2019

##############################################
##### PAM of MapMan BINs CNV with CCP values #######
##############################################

workDir="/data/g4c/downstream/AA_Seqs/Mercator4/PAM"

library(ape)
library(caper)


# load species tree
pls.tree <- read.tree("P1.raxml.support.rooted.tre")


# load phenotype: CCP values
m <- read.csv("CCP.tab", sep="\t")
pheno <- m$CCP
names(pheno) <- m$Species


#### With ratios #####
dd <- read.table("AllSps_Mercator.results.ratios.tab", header=T, sep="\t")
dim(dd)
# 6472 32


geno <- dd
rownames(geno) <- dd[,1]
geno$BIN <- NULL

dim(geno)
# 6472 31


# subset genotypes for species with phenotype
asso_matrix <- geno[,names(pheno)]
dim(asso_matrix)
# 6472 31

t_asso_matrix <- t(asso_matrix)
dim(t_asso_matrix)
# 31 6472


if (!is.factor(pheno)) {
	t_asso_matrix <- t_asso_matrix[pheno >= 0,]
}

dim(t_asso_matrix)
# 31 6472


t_asso_matrix_uniq =  t_asso_matrix

# Exclude HOGs that contains just presence or absence of genes, i.e., 0 or 1
mod_tab <- t_asso_matrix_uniq[,colSums(t_asso_matrix_uniq == 1 | t_asso_matrix_uniq == 0) != nrow(t_asso_matrix_uniq)]
dim(mod_tab)
# 31 6472

# Exclude hogs which contains <=3 species
#mod_tab2 <- mod_tab[,colSums(mod_tab !=0)>=3]
#dim(mod_tab2)
# 31 27992

# Exclude hogs which contains <=7 species
mod_tab2 <- mod_tab[,colSums(mod_tab !=0)>=7]
dim(mod_tab2)
# 31 6384

#mod_tab3 <- mod_tab2[,colSums(mod_tab2 ==0)>=3]
#dim(mod_tab3)
# 31 14909

mod_tab3 <- mod_tab2  # We keep gene families with all species too.

total_groups <- 0
count_groups <- 0
results <- list()
hogs <- list()


for(og_id in colnames(mod_tab3)) {
	total_groups <- total_groups + 1
	
	# Build up HOG specific data
	c_pheno = c()
	c_og = c()
	
	if (!is.factor(pheno)) {
		c_pheno <- pheno[pheno >= 0 & is.na(mod_tab3[,og_id])==FALSE]
		c_og <- mod_tab3[pheno >= 0 & is.na(mod_tab3[,og_id])==FALSE, og_id]
	} else {
		c_pheno <- pheno[is.na(mod_tab3[,og_id])==FALSE]
		c_og <- mod_tab3[is.na(mod_tab3[,og_id])==FALSE, og_id]
	}

	n_og <- c_og
	n_og[n_og == 0] <- "No"
	n_og[n_og >= 1 & n_og != "No"] <- "Yes"
	n_og <- as.factor(n_og)
	c_species <- names(c_pheno)

	#if(length(n_og[n_og == "Yes"]) > 3 && length(n_og[n_og == "No"]) > 3 && length(n_og) > length(mod_tab2[, 1])*0.80){
	print(og_id)
	count_groups <- count_groups + 1
	hogs[[og_id]] <- og_id
		
	# Prepare data for caper
	pp.data <- as.data.frame(c_species)
	pp.data <- cbind(pp.data, c_pheno)
	pp.data <- cbind(pp.data, n_og)
	pp.data <- cbind(pp.data, c_og)
	print(pp.data)		
	pp <- comparative.data(pls.tree, pp.data, c_species, na.omit=FALSE)
	print("###################")
	print(pp)
	print("###################")		
		
	#if (!is.factor(pheno)) {
	#mod1 <- anova(brunch(c_pheno ~ n_og, pp, equal.branch.length=TRUE))
	mod1 <- anova(crunch(c_pheno ~ c_og, pp, equal.branch.length=TRUE))
	results[[og_id]] <- mod1
		#}
	#}
	#rm(c_pheno, c_og,  n_og, c_species, pp.data, pp)
}


# Extract pvalues from anova outputs
pval = list()
for (i in 1:length(results)) {
	for (name in names(results[i])) { 
		pval[name] = results[i][[name]]$"Pr(>F)"[1]
	}
}

pval_sig = pval[pval<0.05] # 763 HOGs
pval_hsig = pval[pval<0.01] # 217 HOGs

# With at least 7 species!
write.table(as.matrix(hogs), file = paste("7_SPS_BINs_CNV_Ratios.ID", sep="\t"), row.names=FALSE, col.names=FALSE, append=FALSE, quote=FALSE)
write.table(as.matrix(pval_sig), file = paste("7_SPS_BINs_CNV_Ratios_PAM.sig.out", sep="\t"), row.names=TRUE, col.names=FALSE, append=FALSE, quote=FALSE)
write.table(as.matrix(pval_hsig), file = paste("7_SPS_BINs_CNV_Ratios_PAM.hsig.out", sep="\t"), row.names=TRUE, col.names=FALSE, append=FALSE, quote=FALSE)

### END ###