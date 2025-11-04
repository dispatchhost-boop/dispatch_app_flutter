//
//  DigioKycResponse.swift
//  kyc_workflow
//
//  Created by Naman on 03/01/23.
//

import Foundation


struct DigioKycResponse: Codable{
    let status: String?
    let message: String?
    let id: String?
    let code: Int?
    let errorCode: Int?
    let type: String?
    let screen: String?
    let npciTxnId: String?
    let txnId: String?
}
