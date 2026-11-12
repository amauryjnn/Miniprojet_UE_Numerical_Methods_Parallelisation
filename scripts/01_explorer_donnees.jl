include(joinpath(@__DIR__, "..", "src", "donnees.jl"))
include(joinpath(@__DIR__, "..", "src", "visualisation.jl"))

img, sources, rgb = charger_donnees()
H, W, L = size(img)

println("Cube hyperspectral : ", size(img), "   (hauteur, largeur, bandes)")
println("Spectres purs      : ", size(sources), "   (bandes, materiaux)")

# On passe au format matriciel X = S*A : une colonne par pixel
X = image_vers_matrice(img)
println("Matrice X          : ", size(X), "   (bandes, pixels)")
println("Valeurs de X       : entre ", minimum(X), " et ", maximum(X))

# On verifie : l'aller-retour image -> matrice -> image ne doit rien perdre
println("Aller-retour image <-> matrice correct ? ", matrice_vers_image(X, H, W) == img)

# Figures
dossier = dossier_resultats()
savefig(afficher_image_rgb(rgb), joinpath(dossier, "donnees_rgb.png"))
savefig(afficher_bande(img, 150), joinpath(dossier, "donnees_bande_150.png"))
savefig(afficher_endmembers(sources), joinpath(dossier, "donnees_endmembers.png"))
savefig(afficher_spectre_pixel(img, 100, 100), joinpath(dossier, "donnees_spectre_pixel.png"))
println("Figures enregistrees dans : ", dossier)
