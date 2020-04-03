//
//  CountryDetail.swift
//  CovidCases
//
//  Created by Imthath M on 03/04/20.
//  Copyright © 2020 Imthath. All rights reserved.
//

import SwiftUI

struct CountryDetail: View {
    let country: Country
    
    var body: some View {
        Text(country.name)
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail(country: Model.country)
    }
}
