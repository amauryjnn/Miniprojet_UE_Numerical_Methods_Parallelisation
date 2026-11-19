using LinearAlgebra

"""
    pas_de_gradient(S)

Pas de la descente de gradient : l'inverse de la norme d'operateur de S'S.
"""
function pas_de_gradient(S)
    return 1 / opnorm(S' * S)
end

"""
    appliquer_contrainte!(A, contrainte)

Projette `A` (vecteur ou matrice) selon la contrainte choisie.
- `:positif`  : abondances >= 0 (ANC)
- `:simplexe` : abondances >= 0 ET somme egale a 1 pour chaque pixel (ANC + ASC)
"""
function appliquer_contrainte!(A, contrainte)
    if contrainte == :positif
        projeter_positif!(A)
    elseif contrainte == :simplexe
        if A isa AbstractVector
            A .= projeter_simplexe(A)          # un seul pixel
        else
            projeter_simplexe_colonnes!(A)     # tous les pixels (une colonne chacun)
        end
    else
        error("Contrainte inconnue : $contrainte (choix possibles : :positif, :simplexe)")
    end
    return A
end

"""
    gradient_projete_global(X, S; contrainte = :positif, tol = 1e-4, iter_max = 2000)

Estime la matrice d'abondances `A` (taille P x N) pour tous les pixels en meme temps.

Arguments :
- `X`        : matrice des donnees (L x N)
- `S`        : matrice des spectres purs (L x P)
- `contrainte` : `:positif` ou `:simplexe`
- `tol`      : on s'arrete quand la variation relative de A entre deux iterations est < tol
- `iter_max` : nombre maximal d'iterations (securite)

Retourne `(A, nb_iterations, historique)` ou `historique` contient la variation a chaque iteration.
"""
function gradient_projete_global(X, S; contrainte = :positif, tol = 1e-4, iter_max = 2000)
    P = size(S, 2)
    N = size(X, 2)

    # Ces deux matrices ne changent pas : on les calcule UNE seule fois (gain de temps)
    StS = S' * S          # taille P x P
    StX = S' * X          # taille P x N
    rho = pas_de_gradient(S)

    A = fill(1 / P, P, N)           # depart : meme proportion pour tous les materiaux
    historique = Float64[]

    for k in 1:iter_max
        A_ancien = copy(A)

        gradient = StS * A - StX             # gradient de la fonction a minimiser
        A = A - rho * gradient               # pas de descente
        appliquer_contrainte!(A, contrainte) # on revient dans l'ensemble autorise

        variation = norm(A - A_ancien) / norm(A_ancien)
        push!(historique, variation)
        if variation < tol
            return A, k, historique
        end
    end

    return A, iter_max, historique
end
