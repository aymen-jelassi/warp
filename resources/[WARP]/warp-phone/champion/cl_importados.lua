RegisterNUICallback('importados', function()

    SendNUIMessage({ openSection = "importados", showCarPaymentsOwed = showCarPayments, vehicleData = parsedVehicleData})
  end)

  RegisterNUICallback('job-center', function()
    SendNUIMessage({ openSection = "job-center"})
  end)