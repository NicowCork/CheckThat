//
//  ButtonsController.swift
//  CheckThat
//
//  Created by Nicolas on 21/06/2025.
//

import Foundation

enum ButtonsControllerState {
    case only_file_and_pieces_allowed
    case rank_and_file_allowed
    case only_rank_allowed
    case only_file_allowed
    case only_take_allowed
    case only_check_allowed
    case nothing_allowed
    case take_allowed
    case check_allowed
}

//enum ButtonsControllerState {
//    case start_default
//    case pawn
//    case pawn_rank
//    case pawn_taking
//    case pawn_taking_file
//    case pawn_taking_file_rank
//    case pawn_promotion
//    case pawn_promotion_check
//    case piece
//    case piece_file
//    case piece_file_rank
//    case piece_moving
//    case piece_taking
//    case piece_taking_file
//    case piece_taking_file_rank
//    case piece_taking_check
//    case all_rocks
//    case full_move
//}

enum movesRegexes: String {
    case start_default = "^\\.\\.\\.$" // rien entré
    case pawn = "^[a-h]$" // début d'un pion
    case pawn_rank = #"^[a-h][1-8]?$"# // pion mouvement simple
    case pawn_taking = #"^[a-h]x?$"# // pion qui va capturer
    case pawn_taking_file = #"^[a-h]x[a-h]?$"# // pion capture colonne
    case pawn_taking_file_rank = #"^[a-h]x[a-h][1-8]?$"# // pion capture complète
    case pawn_promotion = #"^[a-h]8=[QRBN]$"# // promotion simple
    case pawn_promotion_check = #"^[a-h]8=[QRBN][+#]?$"# // promotion + éventuellement échec
    case piece = "^[KQRBN]$" // début d'une pièce
    case piece_file = "^[KQRBN][a-h]?$" // pièce + colonne
    case piece_file_rank = "^[KQRBN][a-h]?[1-8]?$" // pièce + colonne + ligne
    case piece_moving_file = "^[KQRBN][a-h]?[1-8]?[a-h]?$" // déplacement sans capture
    case piece_moving_file_rank = "^[KQRBN][a-h]?[1-8]?[a-h]?[1-8]?$" // déplacement sans capture
    case piece_taking = "^[KQRBN][a-h]?[1-8]?x?$" // pièce qui va capturer
    case piece_taking_file = "^[KQRBN][a-h]?[1-8]?x[a-h]?$" // capture destination (colonne)
    case piece_taking_file_rank = "^[KQRBN][a-h]?[1-8]?x[a-h][1-8]?$" // capture destination complète
    case piece_taking_check = "^[KQRBN][a-h]?[1-8]?x[a-h][1-8][+#]?$" // capture complète + échec
    case all_rocks = "^O-O(-O)?\\+?$" // roque court ou long, éventuellement suivi de +
    case full_move = "^([KQRBN][a-h]?[1-8]?x?[a-h][1-8]|[a-h](x[a-h])?[1-8](=[QRBN])?)[+#]?$" // Coup valide?
}

