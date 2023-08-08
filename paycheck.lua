function StartPayCheck()
  CreateThread(function()
    while true do
      Wait(Config.PaycheckInterval)

      for player, xPlayer in pairs(ESX.Players) do
        local job = xPlayer.job.grade_name
        local salary = xPlayer.job.grade_salary

        if salary > 0 then
          if job == 'unemployed' then -- unemployed
            xPlayer.addAccountMoney('bank', salary, "Welfare Check")
              TriggerClientEvent('ox_lib:notify', player, {
                title = 'Welfare Check', 
                description = 'You have received a check from the government deposited into your account in the amount: $'.. salary ..'',
                type = 'success',  ---Center, top-right, top, ---Customize your notify look.
                position = 'center',
                duration = 8000,
                style = {
                  backgroundColor = '#141517',
                  color = '#C1C2C5',
                  ['.description'] = {
                    color = '#909296', --- for icon color or just color of background go here https://mantine.dev/theming/colors/#default-colors
                  }
                },
                icon = 'money-check-dollar', --- Icons for notify go to https://fontawesome.com/icons
                iconColor = '#8C0303' })
          elseif Config.EnableSocietyPayouts then -- possibly a society
            TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(society)
              if society ~= nil then -- verified society
                TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                  if account.money >= salary then -- does the society money to pay its employees?
                    xPlayer.addAccountMoney('bank', salary, "Paycheck")
                    account.removeMoney(salary)

                    TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), TranslateCap('received_paycheck'),
                      TranslateCap('received_salary', salary), 'CHAR_BANK_MAZE', 9)
                  else
                    TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), '', TranslateCap('company_nomoney'), 'CHAR_BANK_MAZE', 1)
                  end
                end)
              else -- not a society
                xPlayer.addAccountMoney('bank', salary, "Paycheck")
                TriggerClientEvent('ox_lib:notify', player, { 
                  title = 'Paycheck', 
                  description = 'Your paycheck has been deposited into your account in the amount: $'.. salary ..'',
                  type = 'success',
                  position = 'center', ---Center, top-right, top, ---Customize your notify look.
                  duration = 8000,
                  style = {
                    backgroundColor = '#141517',
                    color = '#C1C2C5',
                    ['.description'] = {
                      color = '#2C2C2C',
                    }
                  },
                  icon = 'sack-dollar',
                  iconColor = '#8C0303' })
              end
            end)
          else -- generic job
            xPlayer.addAccountMoney('bank', salary, "Paycheck")
            TriggerClientEvent('ox_lib:notify', player, { 
              title = 'Paycheck', 
              description = 'Your paycheck has been deposited into your account in the amount: $'.. salary ..'',
              type = 'success',
              position = 'top', ---Center, top-right, top, ---Customize your notify look.
              duration = 6000,
              style = {
                backgroundColor = '#141517',
                color = '#2C2C2C',
                ['.description'] = {
                  color = '#2C2C2C',
                }
              },
              icon = 'sack-dollar',
              iconColor = '#8C0303' })
          end
        end
      end
    end
  end)
end