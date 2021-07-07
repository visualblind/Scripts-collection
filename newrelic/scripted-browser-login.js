/**
 * Feel free to explore, or check out the full documentation
 * https://docs.newrelic.com/docs/synthetics/new-relic-synthetics/scripting-monitors/writing-scripted-browsers
 * for details.
 */

$browser.addHeader('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36');
$browser.get("https://travisflix.com/web/index.html#!/login.html?serverid=46ea2802a29842669dac695996e2c2ac").then(function(){

return $browser.findElement($driver.By.id("txtManualName")).sendKeys("testuser");
}).then(function(){
return $browser.findElement($driver.By.id("txtManualPassword")).sendKeys("DrewGe*f9");
}).then(function(){
return $browser.findElement($driver.By.xpath("/html/body/div[5]/div/div/form/button")).click();
}).then(function(){
    //Call the wait function to wait until the Movies link appears.
    return $browser.waitForAndFindElement($driver.By.xpath("/html/body/div[5]/div/div[1]/div/div[1]/div[2]/div/div[1]/div/div[2]/button"), 20000).then(function(moviesPage){
        return moviesPage.click();
    })
}).then(function(){
    //Call the wait function to wait until the next page arrow button appears.
    return $browser.waitForAndFindElement($driver.By.className("btnNextPage autoSize paper-icon-button-light"), 20000).then(function(nextPage){
        return nextPage.click();
        //If the condition isn't satisfied within 20000 milliseconds (20 seconds), proceed anyway.
});
    }).then(function(){
    //Call the wait function to wait until the next page arrow button appears.
    return $browser.waitForAndFindElement($driver.By.className("btnNextPage autoSize paper-icon-button-light"), 20000).then(function(nextPage){
        return nextPage.click();
        //If the condition isn't satisfied within 20000 milliseconds (20 seconds), proceed anyway.
});
    }).then(function(){
    //Call the wait function to wait until the next page arrow button appears.
    return $browser.waitForAndFindElement($driver.By.className("btnNextPage autoSize paper-icon-button-light"), 20000).then(function(nextPage){
        return nextPage.click();
        //If the condition isn't satisfied within 20000 milliseconds (20 seconds), proceed anyway.
});
    }).then(function(){
    //Call the wait function to wait until the next page arrow button appears.
    return $browser.waitForAndFindElement($driver.By.className("btnNextPage autoSize paper-icon-button-light"), 20000).then(function(nextPage){
        return nextPage.click();
        //If the condition isn't satisfied within 20000 milliseconds (20 seconds), proceed anyway.
});
    });