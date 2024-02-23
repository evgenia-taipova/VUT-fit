/*
 * Binárny vyhľadávací strom — rekurzívna varianta
 *
 * S využitím dátových typov zo súboru btree.h a pripravených kostier funkcií
 * implementujte binárny vyhľadávací strom pomocou rekurzie.
 */

#include "../btree.h"
#include <stdio.h>
#include <stdlib.h>

/*
 * Inicializácia stromu.
 *
 * Užívateľ musí zaistiť, že incializácia sa nebude opakovane volať nad
 * inicializovaným stromom. V opačnom prípade môže dôjsť k úniku pamäte (memory
 * leak). Keďže neinicializovaný ukazovateľ má nedefinovanú hodnotu, nie je
 * možné toto detegovať vo funkcii.
 */
void bst_init(bst_node_t **tree)
{
  *tree = NULL;
}

/*
 * Nájdenie uzlu v strome.
 *
 * V prípade úspechu vráti funkcia hodnotu true a do premennej value zapíše
 * hodnotu daného uzlu. V opačnom prípade funckia vráti hodnotu false a premenná
 * value ostáva nezmenená.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
bool bst_search(bst_node_t *tree, char key, int *value)
{
  if (!tree)
    return false;
  if (tree->key == key)
  {
    *value = tree->value;
    return true;
  }
  if (key < tree->key)
    return bst_search(tree->left, key, value);
  return bst_search(tree->right, key, value);
}

/*
 * Vloženie uzlu do stromu.
 *
 * Pokiaľ uzol so zadaným kľúčom v strome už existuje, nahraďte jeho hodnotu.
 * Inak vložte nový listový uzol.
 *
 * Výsledný strom musí spĺňať podmienku vyhľadávacieho stromu — ľavý podstrom
 * uzlu obsahuje iba menšie kľúče, pravý väčšie.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_insert(bst_node_t **tree, char key, int value)
{
  if (!*tree)
  {
    *tree = (bst_node_t *)malloc(sizeof(struct bst_node));
    if (*tree)
    {
      (*tree)->key = key;
      (*tree)->value = value;
      (*tree)->left = NULL;
      (*tree)->right = NULL;
    }
    else
      return;
  }
  if (key < (*tree)->key)
  {
    bst_insert(&((*tree)->left), key, value);
    return;
  }
  else if (key > (*tree)->key)
  {
    bst_insert(&((*tree)->right), key, value);
    return;
  }
  else if (key == (*tree)->key)
  {
    (*tree)->value = value;
    return;
  }
}

/*
 * Pomocná funkcia ktorá nahradí uzol najpravejším potomkom.
 *
 * Kľúč a hodnota uzlu target budú nahradené kľúčom a hodnotou najpravejšieho
 * uzlu podstromu tree. Najpravejší potomok bude odstránený. Funkcia korektne
 * uvoľní všetky alokované zdroje odstráneného uzlu.
 *
 * Funkcia predpokladá že hodnota tree nie je NULL.
 *
 * Táto pomocná funkcia bude využitá pri implementácii funkcie bst_delete.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_replace_by_rightmost(bst_node_t *target, bst_node_t **tree)
{
  bst_node_t *rightmost;
  if (!(*tree)->right)
  {
    rightmost = *tree;
    target->key = rightmost->key;
    target->value = rightmost->value;
    target->left = NULL;
    if (rightmost->left)
      target->left = rightmost->left;
    free(rightmost);
    return;
  }
  if (!(*tree)->right->right)
  {
    rightmost = (*tree)->right;
    target->key = rightmost->key;
    target->value = rightmost->value;
    (*tree)->right = NULL;
    if (rightmost->left)
      (*tree)->right = rightmost->left;
    free(rightmost);
    return;
  }
  bst_replace_by_rightmost(target, &((*tree)->right));
}

/*
 * Odstránenie uzlu v strome.
 *
 * Pokiaľ uzol so zadaným kľúčom neexistuje, funkcia nič nerobí.
 * Pokiaľ má odstránený uzol jeden podstrom, zdedí ho otec odstráneného uzla.
 * Pokiaľ má odstránený uzol oba podstromy, je nahradený najpravejším uzlom
 * ľavého podstromu. Najpravejší uzol nemusí byť listom!
 * Funkcia korektne uvoľní všetky alokované zdroje odstráneného uzlu.
 *
 * Funkciu implementujte rekurzívne pomocou bst_replace_by_rightmost a bez
 * použitia vlastných pomocných funkcií.
 */
void bst_delete(bst_node_t **tree, char key)
{
  bst_node_t *delete;
  if (!*tree)
    return;
  if (key < (*tree)->key)
  {
    delete = (*tree)->left;
    if (delete &&delete->key == key)
    {
      if (delete->left && delete->right)
      {
        bst_replace_by_rightmost(delete, &(delete->left));
        return;
      }
      if (!delete->left && delete->right)
        (*tree)->left = delete->right;
      else if (!delete->right && delete->left)
        (*tree)->left = delete->left;
      else
        (*tree)->left = NULL;
      free(delete);
      return;
    }
    bst_delete(&((*tree)->left), key);
    return;
  }
  if (key > (*tree)->key)
  {
    bst_delete(&((*tree)->right), key);
    return;
  }
  if (key == (*tree)->key)
  {
    delete = *tree;
    if (delete->left && delete->right)
    {
      bst_replace_by_rightmost(delete, &(delete->left));
      return;
    }
    if (!delete->left && delete->right)
      *tree = delete->right;
    else if (!delete->right && delete->left)
      *tree = delete->left;
    else
      *tree = NULL;
    free(delete);
  }
}

/*
 * Zrušenie celého stromu.
 *
 * Po zrušení sa celý strom bude nachádzať v rovnakom stave ako po
 * inicializácii. Funkcia korektne uvoľní všetky alokované zdroje rušených
 * uzlov.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_dispose(bst_node_t **tree)
{
  if (*tree)
  {
    bst_dispose(&((*tree)->left));
    bst_dispose(&((*tree)->right));
    free(*tree);
    *tree = NULL;
  }
}

/*
 * Preorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_preorder(bst_node_t *tree)
{
  if (tree)
  {
    bst_print_node(tree);
    bst_preorder(tree->left);
    bst_preorder(tree->right);
  }
}

/*
 * Inorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_inorder(bst_node_t *tree)
{
  if (tree)
  {
    bst_inorder(tree->left);
    bst_print_node(tree);
    bst_inorder(tree->right);
  }
}
/*
 * Postorder prechod stromom.
 *
 * Pre aktuálne spracovávaný uzol nad ním zavolajte funkciu bst_print_node.
 *
 * Funkciu implementujte rekurzívne bez použitia vlastných pomocných funkcií.
 */
void bst_postorder(bst_node_t *tree)
{
  if (tree)
  {
    bst_postorder(tree->left);
    bst_postorder(tree->right);
    bst_print_node(tree);
  }
}
