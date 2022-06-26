
MenuData = {
  apartment_check = {
    {
      title = "Apartment",
      description = "Forclose Apartment",
      key = "judge",
      children = {
          { title = "Yes", action = "warp-apartments:handler", key = { forclose = true} },
          { title = "No", action = "warp-apartments:handler", key = { forclose = false } },
      }
    }
  }
}
