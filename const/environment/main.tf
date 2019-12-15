locals {
    subscriptions = {
        default    = ""
        staging    = "40371827-837f-4329-a4c1-1000a8a29725"
        production = "d4a41ee3-311b-4c4e-925f-efe88c259051"
    }

    env_sub_mapping = {
        default = ""
        dev     = "${local.subscriptions["staging"]}"
        prd     = "${local.subscriptions["production"]}"
    }

    locations = {
        default = ""
        dev = "australiasoutheast"
        prd = "australiaeast"
    }

    kv_rw = {
        default = []
        dev = [
            "43ca4e5d-30ec-4e08-b004-5a76178a0072", # TFC
            "24a210e1-db99-4fe1-a7f8-35d1d3813e26", # me
        ]
        prd = [
            "318d2d14-2fb8-425f-a379-83aaea4b3cff", # TFC
            "24a210e1-db99-4fe1-a7f8-35d1d3813e26", # me
        ]
    }
    kv_ro = {
        default = []
        dev = []
        prd = []

    }
}