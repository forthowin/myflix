
[1mFrom:[0m /home/tho/projects/myflix/app/services/user_signup.rb @ line 9 UserSignup#sign_up:

     [1;34m8[0m: [32mdef[0m [1;34msign_up[0m(stripe_token, invitation_token)
 =>  [1;34m9[0m:   binding.pry
    [1;34m10[0m:   [32mif[0m @user.valid?
    [1;34m11[0m:     charge = [1;34;4mStripeWrapper[0m::[1;34;4mCharge[0m.create(
    [1;34m12[0m:       [33m:amount[0m => [1;34m999[0m,
    [1;34m13[0m:       [33m:source[0m => stripe_token,
    [1;34m14[0m:       [33m:description[0m => [31m[1;31m"[0m[31mSign up charge for #{@user.email}[0m[31m[1;31m"[0m[31m[0m
    [1;34m15[0m:     )
    [1;34m16[0m:     [32mif[0m charge.successful?
    [1;34m17[0m:       @user.save
    [1;34m18[0m:       handle_token(invitation_token)
    [1;34m19[0m:       [1;34;4mAppMailer[0m.delay.send_welcome_mail(@user)
    [1;34m20[0m:       @user_id = @user.id
    [1;34m21[0m:       @status = [33m:success[0m
    [1;34m22[0m:       [1;36mself[0m
    [1;34m23[0m:     [32melse[0m
    [1;34m24[0m:       @error_message = charge.error_message
    [1;34m25[0m:       @status = [33m:failed[0m
    [1;34m26[0m:       [1;36mself[0m
    [1;34m27[0m:     [32mend[0m
    [1;34m28[0m:   [32melse[0m
    [1;34m29[0m:     @error_message = [31m[1;31m"[0m[31mThere were some errors.[1;31m"[0m[31m[0m
    [1;34m30[0m:     @status = [33m:failed[0m
    [1;34m31[0m:     [1;36mself[0m
    [1;34m32[0m:   [32mend[0m
    [1;34m33[0m: [32mend[0m

