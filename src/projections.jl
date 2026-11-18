"""
    projeter_positif!(A)

Projection sur les nombres positifs (contrainte ANC) : toutes les valeurs
negatives sont remplacees par 0. Modifie `A` directement (le `!` le signale).
Marche pour un vecteur comme pour une matrice.
"""
function projeter_positif!(A)
    for k in eachindex(A)
        if A[k] < 0
            A[k] = 0
        end
    end
    return A
end

"""
    projeter_simplexe(v)

Projection d'un vecteur `v` sur le simplexe {a : a >= 0 et somme(a) = 1}
(contraintes ANC + ASC). Retourne un NOUVEAU vecteur.

Methode (algorithme classique de Duchi et al., 2008) :
  1. on trie les valeurs de la plus grande a la plus petite ;
  2. on cherche un seuil `theta` tel que  max(v - theta, 0)  ait une somme egale a 1 ;
  3. on retire `theta` a toutes les valeurs, puis on met les negatifs a 0.
"""
function projeter_simplexe(v)
    P = length(v)
    u = sort(v, rev = true)          # valeurs triees par ordre decroissant

    somme_cumulee = 0.0
    somme_retenue = 0.0
    nb_actifs = 0                    # nombre de composantes qui resteront > 0
    for j in 1:P
        somme_cumulee += u[j]
        seuil_possible = (somme_cumulee - 1) / j
        if u[j] - seuil_possible > 0     # la j-eme plus grande valeur reste positive
            nb_actifs = j
            somme_retenue = somme_cumulee
        end
    end

    theta = (somme_retenue - 1) / nb_actifs
    return max.(v .- theta, 0)
end

"""
    projeter_simplexe_colonnes!(A)

Applique `projeter_simplexe` a chaque colonne de la matrice `A` (une colonne = un pixel).
Modifie `A` directement.
"""
function projeter_simplexe_colonnes!(A)
    for n in 1:size(A, 2)
        A[:, n] = projeter_simplexe(A[:, n])
    end
    return A
end
