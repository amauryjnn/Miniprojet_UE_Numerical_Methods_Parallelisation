using LinearAlgebra

"""
    erreur_reconstruction(X, S, A)

Erreur relative de reconstruction  ||X - S*A|| / ||X||  (norme de Frobenius).
Plus elle est petite, mieux le modele  X ~ S*A  explique l'image.
"""
function erreur_reconstruction(X, S, A)
    return norm(X - S * A) / norm(X)
end

"""
    verifier_contraintes(A)

Retourne `(plus_petite_valeur, ecart_max_a_1)` :
- `plus_petite_valeur` doit etre >= 0 (contrainte ANC)
- `ecart_max_a_1` est le plus grand |somme_des_abondances - 1| sur les pixels,
  il doit etre proche de 0 si la contrainte ASC est imposee.
"""
function verifier_contraintes(A)
    plus_petite_valeur = minimum(A)
    ecart_max_a_1 = maximum(abs.(sum(A, dims = 1) .- 1))
    return plus_petite_valeur, ecart_max_a_1
end

"""
    mesurer_temps(f; repetitions = 3, echauffement = true)

Mesure le temps d'execution (en secondes) de la fonction sans argument `f`.

Pourquoi un "echauffement" ? Julia compile une fonction la PREMIERE fois qu'on
l'appelle : ce premier appel est donc plus lent et fausserait la mesure.
On l'execute une fois dans le vide, puis on garde le MEILLEUR temps des `repetitions` suivantes.
"""
function mesurer_temps(f; repetitions = 3, echauffement = true)
    if echauffement
        f()
    end
    meilleur = Inf
    for _ in 1:repetitions
        t = @elapsed f()
        meilleur = min(meilleur, t)
    end
    return meilleur
end
