//
//  ButtonsController.swift
//  CheckThat
//
//  Created by Nicolas on 21/06/2025.
//

import Foundation

struct ButtonsController {
    var isTakeAllowed: Bool = false
    var isCheckAllowed: Bool = false
    var isRankAllowed: Bool = false
    var isFileAllowed: Bool = true
    var isPiecesAllowed: Bool = true
    
    mutating func ControlButtons(forInput input: String) {
        if input.matches(movesRegexes.whileTaking.rawValue) {
            isFileAllowed = true
            isRankAllowed = false
        }
        
        if input == "..." {
            isTakeAllowed = false
            isCheckAllowed = false
            isRankAllowed = false
            isFileAllowed = true
            isPiecesAllowed = true
        }
        if input.matches(movesRegexes.isFileAllowed.rawValue) {
            isFileAllowed = true
            isRankAllowed = false
        }
        
        if input.matches(movesRegexes.isPiecesAllowed.rawValue) {
            isPiecesAllowed = true
        } else { isPiecesAllowed = false }
        if input.matches(movesRegexes.isRankAllowed.rawValue) {
            isRankAllowed = true
            isFileAllowed = false
        }
        if input.matches(movesRegexes.isTakeAllowed.rawValue) { isTakeAllowed = true } else { isTakeAllowed = false }
        if input.matches(movesRegexes.isCheckAllowed.rawValue) { isCheckAllowed = true } else { isCheckAllowed = false }
    }
}

enum movesRegexes: String {
    case isTakeAllowed = "^([KQRBN]|[a-h])([a-h1-8]?)([a-h1-8]?)$"
    case isCheckAllowed = "^([KQRBN]?[a-h]?[1-8]?x?[a-h][1-8]|O-O(-O)?)$"
    case isRankAllowed = "^([KQRBN]?[a-h]?[1-8]?x?[a-h]?)$"
    case isFileAllowed = "^([KQRBN]?[a-h]?[1-8]?x?)?$"
    case isPiecesAllowed = "^$|^O$"
    case whileTaking = ".+x$"
}
    
//    case start_default = "^\\.\\.\\.$" // rien entré
//    case pawn = "^[a-h]$" // début d'un pion
//    case pawn_rank = #"^[a-h][1-8]?$"# // pion mouvement simple
//    case pawn_taking = #"^[a-h]x?$"# // pion qui va capturer
//    case pawn_taking_file = #"^[a-h]x[a-h]?$"# // pion capture colonne
//    case pawn_taking_file_rank = #"^[a-h]x[a-h][1-8]?$"# // pion capture complète
//    case pawn_promotion = #"^[a-h]8=[QRBN]$"# // promotion simple
//    case pawn_promotion_check = #"^[a-h]8=[QRBN][+#]?$"# // promotion + éventuellement échec
//    case piece = "^[KQRBN]$" // début d'une pièce
//    case piece_file = "^[KQRBN][a-h]?$" // pièce + colonne
//    case piece_file_rank = "^[KQRBN][a-h]?[1-8]?$" // pièce + colonne + ligne
//    case piece_moving_file = "^[KQRBN][a-h]?[1-8]?[a-h]?$" // déplacement sans capture
//    case piece_moving_file_rank = "^[KQRBN][a-h]?[1-8]?[a-h]?[1-8]?$" // déplacement sans capture
//    case piece_taking = "^[KQRBN][a-h]?[1-8]?x?$" // pièce qui va capturer
//    case piece_taking_file = "^[KQRBN][a-h]?[1-8]?x[a-h]?$" // capture destination (colonne)
//    case piece_taking_file_rank = "^[KQRBN][a-h]?[1-8]?x[a-h][1-8]?$" // capture destination complète
//    case piece_taking_check = "^[KQRBN][a-h]?[1-8]?x[a-h][1-8][+#]?$" // capture complète + échec
//    case all_rocks = "^O-O(-O)?\\+?$" // roque court ou long, éventuellement suivi de +
//    case full_move = "^([KQRBN][a-h]?[1-8]?x?[a-h][1-8]|[a-h](x[a-h])?[1-8](=[QRBN])?)[+#]?$" // Coup valide?
//    case isTakeAllowed = "^[abcdefghKGRBN]"
    
    //        if input.matches(movesRegexes.start_default.rawValue) {
    //            print("...")
    //            move_validation = .only_file_and_pieces_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.pawn.rawValue) {
    //            print("only file")
    //            move_validation = .only_rank_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.pawn_rank.rawValue) {
    //            print("pawn rank ")
    //            move_validation = .only_take_allowed //valid
    //            return
    //        }
    //        if input.matches(movesRegexes.pawn_taking.rawValue) {
    //            print("pawn taking")
    //            move_validation = .only_file_and_pieces_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.pawn_taking_file.rawValue) {
    //            print("pawn taking")
    //            move_validation = .only_rank_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.pawn_taking_file_rank.rawValue) {
    //            print("pawn taking file")
    //            move_validation = .only_check_allowed //valid
    //            return
    //        }
    //        if input.matches(movesRegexes.pawn_promotion.rawValue) {
    //            print("pawn promotion")
    //            move_validation = .pawn_promotion
    //            return
    //        }
    //        if input.matches(movesRegexes.pawn_promotion_check.rawValue) {
    //            print("pawn promotion check")
    //            move_validation = .pawn_promotion_check
    //            return
    //        }
    //        if input.matches(movesRegexes.piece.rawValue) {
    //            print("piece")
    //            move_validation = .only_file_and_pieces_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.piece_file.rawValue) {
    //            print("piece file")
    //            move_validation = .only_rank_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.piece_file_rank.rawValue) {
    //            print("piece file rank")
    //            move_validation = .only_check_allowed //valid
    //            return
    //        }
    //        if input.matches(movesRegexes.piece_moving_file.rawValue) {
    //            print("piece moving file")
    //            move_validation = .only_rank_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.piece_moving_file_rank.rawValue) {
    //            print("piece moving file rank")
    //            move_validation = .only_check_allowed // valid
    //            return
    //        }
    //        if input.matches(movesRegexes.piece_taking.rawValue) {
    //            print("piece taking")
    //            move_validation = .only_file_and_pieces_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.piece_taking_file.rawValue) {
    //            print("piece taking file")
    //            move_validation = .only_rank_allowed
    //            return
    //        }
    //        if input.matches(movesRegexes.piece_taking_file_rank.rawValue) {
    //            print("piece taking file rank")
    //            move_validation = .only_check_allowed //valid
    //            return
    //        }
    //        if input.matches(movesRegexes.piece_taking_check.rawValue) {
    //            print("piece taking check")
    //            move_validation = .nothing_allowed //valid
    //            return
    //        }
    //        if input.matches(movesRegexes.all_rocks.rawValue) {
    //            print("All rocks")
    //            move_validation = .only_check_allowed // valid
    //            return
    //        }
    //        if input.matches(movesRegexes.full_move.rawValue) {
    //            print("full move")
    //            move_validation = .full_move
    //            return
    //        }
    //    }
    //}


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


