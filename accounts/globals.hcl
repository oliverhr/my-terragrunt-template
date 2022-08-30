locals {
  company = {
    name = {
      full  = lower("A-Company-Making-Everything")
      short = lower("acme")
    }
  }

  project = {
    name = {
      full  = lower("Wrought-Anvil")
      short = lower("yunke")
    }
  }

  mocked_ids = {
    uuid     = "00000000-0000-0000-0000-000000000000"
    resource = "01234567890abcdef"
  }
}
