using Plots
using DelimitedFiles 

"""
    afficher_image_rgb(rgb)

Affiche l'image en vraies couleurs (tableau H x W x 3, valeurs entre 0 et 1).
"""
function afficher_image_rgb(rgb)
    H, W, _ = size(rgb)
    # on cree un pixel RGB par case
    pixels = [RGB(rgb[i, j, 1], rgb[i, j, 2], rgb[i, j, 3]) for i in 1:H, j in 1:W]
    return plot(pixels, title = "Image en vraies couleurs", axis = nothing,
                aspect_ratio = 1)
end

"""
    afficher_bande(img, numero_bande)

Affiche l'image dans une seule longueur d'onde (une seule bande spectrale).
"""
function afficher_bande(img, numero_bande)
    return heatmap(img[:, :, numero_bande], aspect_ratio = 1, yflip = true,
                   c = :ice, title = "Bande spectrale $numero_bande")
end

"""
    afficher_endmembers(sources; noms)

Trace les spectres purs : un courbe par materiau.
`sources` est de taille (nombre de bandes, nombre de materiaux).
"""
function afficher_endmembers(sources; noms = ["gravier", "herbe", "sol", "arbres"])
    p = plot(title = "Spectres purs des materiaux",
             xlabel = "Bande spectrale", ylabel = "Reflectance")
    for k in 1:size(sources, 2)
        plot!(p, sources[:, k], label = noms[k], linewidth = 2)
    end
    return p
end

"""
    afficher_spectre_pixel(img, i, j)

Trace le spectre du pixel situe a la ligne `i` et la colonne `j`.
"""
function afficher_spectre_pixel(img, i, j)
    return plot(img[i, j, :], label = "pixel ($i, $j)", linewidth = 2,
                xlabel = "Bande spectrale", ylabel = "Reflectance",
                title = "Spectre d'un pixel")
end