function SetDisplay(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        resource = GetCurrentResourceName(),
    })
end

function SetCam(onoff, CamX, CamY, CamZ, CamH)
    if onoff == true then
        if CurrentCam ~= 0 then 
            DestroyCam(CurrentCam)
        end
        CurrentCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(CurrentCam, CamX, CamY, CamZ, CamH)
        SetCamRot(CurrentCam, -21.637795701623, 0.0, CamH)
        SetCamActive(CurrentCam, true)
        RenderScriptCams(1, 1, 750, 1, 1)
    else
        SetCamActive(M1kk4lCurrentCam, false)
        DestroyCam(M1kk4lCurrentCam)
        DetachCam(M1kk4lCurrentCam)
        RenderScriptCams(false, true, 2000, true, true)
    end
end