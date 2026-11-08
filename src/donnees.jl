using MAT   # pour lire les fichiers .mat (format Matlab)

"""
    trouver_dossier_donnees()

Cherche le dossier qui contient `project_data.mat` :
d'abord la variable d'environnement `DONNEES_NUMMET`, ensuite le dossier `data/`.
"""
function trouver_dossier_donnees()
    candidats = String[]
    if haskey(ENV, "DONNEES_NUMMET")
        push!(candidats, ENV["DONNEES_NUMMET"])
    end
    push!(candidats, joinpath(@__DIR__, "..", "data"))

    for dossier in candidats
        if isfile(joinpath(dossier, "project_data.mat"))
            return normpath(dossier)
        end
    end
    error("project_data.mat introuvable. Placez-le dans le dossier data/ (voir data/LISEZMOI.md).")
end

"""
    dossier_resultats()

Retourne le dossier `resultats/` (et le cree s'il n'existe pas) pour y ranger images et fichiers CSV.
"""
function dossier_resultats()
    dossier = normpath(joinpath(@__DIR__, "..", "resultats"))
    mkpath(dossier)
    return dossier
end

"""
    charger_donnees()

Lit `project_data.mat` et retourne trois tableaux :
- `img`     : cube hyperspectral, taille (300, 300, 255)
- `sources` : spectres purs (endmembers), taille (255, 4)
- `rgb`     : image en vraies couleurs pour l'affichage, taille (300, 300, 3)
"""
function charger_donnees()
    chemin = joinpath(trouver_dossier_donnees(), "project_data.mat")
    contenu = matread(chemin)          # dictionnaire "nom de variable" => tableau
    return contenu["im"], contenu["sources"], contenu["rgb"]
end

"""
    image_vers_matrice(img)

Transforme le cube (H, W, L) en matrice X de taille (L, N) avec N = H*W :
chaque COLONNE de X est le spectre d'un pixel.
"""
function image_vers_matrice(img)
    H, W, L = size(img)
    img_bandes_devant = permutedims(img, (3, 1, 2))   # (L, H, W)
    return reshape(img_bandes_devant, L, H * W)
end

"""
    matrice_vers_image(A, H, W)

Operation inverse : transforme une matrice A de taille (P, N) en un cube (H, W, P).
`cube[:, :, p]` est alors la carte (image) du materiau numero p.
"""
function matrice_vers_image(A, H, W)
    P = size(A, 1)
    return permutedims(reshape(A, P, H, W), (2, 3, 1))
end

"""
    extraire_sous_image(img, taille)

Recupere le coin haut-gauche `taille x taille` de l'image (pratique pour tester vite).
"""
function extraire_sous_image(img, taille)
    return img[1:taille, 1:taille, :]
end
