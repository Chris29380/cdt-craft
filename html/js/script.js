
var imgpath = "nui://ox_inventory/web/images/"

window.addEventListener('message', function(event) {
    if (event.data.type == "openUi") {
						
		data = event.data.data
        indexs = event.data.indexs

        progresstick = 0
        tick = 0

		$("body").css("display","flex")
		
		loadmenurecipes()
    }

	if (event.data.type == "closeUi") {
		
		hideUi()
    }

    if (event.data.type == "responsecheckcraft") {

        dataitems = event.data.dataitems
        countCraft = event.data.countCraft
        indexrecipe = event.data.index
        datarecipe = data.recipes[indexrecipe]
        loadrecipe()

    }

    if (event.data.type == "refreshUi") {

        progresstick = progresstick + tick
        $("body .barredefil .contentdefil .progressbar .inprogress").html(``)
        $("body .barredefil .contentdefil .progressbar .barre .inbarre").width(progresstick + "%")
        let progress = Math.round(progresstick)
        htlmInProgress = `Progression en cours... <span style="color:orange">${progress}%</span>`
        $("body .barredefil .contentdefil .progressbar .inprogress").html(htlmInProgress)

    }
})

// functions open / close

function closerecipe() {
    $("body .contentrecipe").css("display","none")
}

function closerecipes() {
    $("body .contentrecipes").css("display","none")
}

function closebarredefil() {
    $("body .barredefil").css("display","none")
}

// functions menu recipes

function loadmenurecipes(){
    closerecipe()
    closebarredefil()
    $("body .contentrecipes").css("display","flex")
    $("body .contentrecipes .boxesrecipes").html("")
	$("body .contentrecipes .title").html(data.label)
    htmlStash = `
        <div class="boxrecipes" id="boxrecipes" onclick="openstash(dataset.indexstash)" data-indexstash=${indexs}>
				<div class="boximg" id="boximg">
					<svg xmlns="http://www.w3.org/2000/svg" height="14" width="17.5" viewBox="0 0 640 512"><!--!Font Awesome Free 6.7.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path fill="#ffffff" d="M58.9 42.1c3-6.1 9.6-9.6 16.3-8.7L320 64 564.8 33.4c6.7-.8 13.3 2.7 16.3 8.7l41.7 83.4c9 17.9-.6 39.6-19.8 45.1L439.6 217.3c-13.9 4-28.8-1.9-36.2-14.3L320 64 236.6 203c-7.4 12.4-22.3 18.3-36.2 14.3L37.1 170.6c-19.3-5.5-28.8-27.2-19.8-45.1L58.9 42.1zM321.1 128l54.9 91.4c14.9 24.8 44.6 36.6 72.5 28.6L576 211.6l0 167c0 22-15 41.2-36.4 46.6l-204.1 51c-10.2 2.6-20.9 2.6-31 0l-204.1-51C79 419.7 64 400.5 64 378.5l0-167L191.6 248c27.8 8 57.6-3.8 72.5-28.6L318.9 128l2.2 0z"/></svg>
				</div>
				<div class="openstashtext" id="openstashtext">
					Ouvrir Stockage
				</div>
		</div>
    `
    for (var index = 0; index < data.recipes.length; index++) {
        htmlStash += `
            <div class="boxrecipes" id="boxrecipes" onclick="sendDataToNui(dataset.type, dataset.id)" data-type="checkcraft" data-id=${index}>
                <div class="boximg">
                    <img src="${imgpath}${data.recipes[index].itemfinal}.png" />
                </div>
                <div class="rightbox" id="rightbox">
                    <div class="labelitemfinal">
                        ${data.recipes[index].labelitemfinal}
                    </div>
                    <div class="qtyfinal">
                        x ${data.recipes[index].qtyfinal}
                    </div>
                </div>
            </div>
        `
    }
    $("body .contentrecipes .boxesrecipes").append(htmlStash)
}

function sendDataToNui(types, indexs){
    let datas = data.recipes[indexs]
    $.post(`https://${GetParentResourceName()}/${types}`, JSON.stringify({data: datas, index: indexs}))
}

function openstash(indexs){
    if (indexs){
        $.post(`https://${GetParentResourceName()}/openstash`, JSON.stringify({index: indexs}))
        hideUi()
    } else {
        console.log("no indexs")
    }
}

// functions recipes

function loadrecipe(){
    closerecipes()
    closebarredefil()
    $("body .contentrecipe").css("display","flex")
    $("body .contentrecipe").html("")

    htmlRecipe = ``

    htmlRecipe += `
        <div class="title" id="title">
            ${datarecipe.labelitemfinal}
        </div>
        <div class="boxrecipe" id="boxrecipe">
            <div class="itemfinal">
                <div class="boximg">
                    <img src="${imgpath}${datarecipe.itemfinal}.png" />
                </div>
                <div class="labelitemfinal">
                    ${datarecipe.labelitemfinal}
                </div>
                <div class="qtyfinal">
                    x ${datarecipe.qtyfinal}
                </div>
            </div>
            <div class="items">
                
            </div>
        </div>
        <div class="actionscraft" id="actionscraft">

        </div>
    `
    var countitem = 0
    htmlItems = ``
    for (var index = 0; index < datarecipe.items.length; index++) {
        for (var index2 = 0; index2 < dataitems.length; index2++) {            
            if (dataitems[index2].name == datarecipe.items[index].name) {
                countitem = dataitems[index2].bag
                console.log("count item: "+dataitems[index2].name+" "+ countitem)
            }
        }
        if (countitem == 0) {
            htmlItems += `
                <div class="item" id="item">
                    <div class="boximgitemfalse">
                        <img src="${imgpath}${datarecipe.items[index].name}.png" />
                    </div>
                    <div class="labelitem">
                        ${datarecipe.items[index].labelitem}
                    </div>
                    <div class="qtyitem">
                        x ${datarecipe.items[index].qty}
                    </div>
                    <div class="qtyiteminv">
                        ${countitem}
                    </div>
                </div>
            `
        } else {
            htmlItems += `
                <div class="item" id="item">
                    <div class="boximgitemtrue">
                        <img src="${imgpath}${datarecipe.items[index].name}.png" />
                    </div>
                    <div class="rightbox" id="rightbox">
                        <div class="labelitem">
                            ${datarecipe.items[index].labelitem}
                        </div>
                        <div class="qtyitem">
                            x ${datarecipe.items[index].qty}
                        </div>
                        <div class="qtyiteminv">
                            ${countitem}
                        </div>
                    </div>
                </div>
            `
        }
        
    }

    $("body .contentrecipe").html(htmlRecipe)
    $("body .contentrecipe .items").html(htmlItems)

    htmlActionsCraft = ``

    htmlActionsCraft = `
        <div class="nbcraft" id="nbcraft">
            <input type="number" id="inpcountcraft" value="0" min="0" max="100">
        </div>
        <div class="validcraft" id="validcraft" onclick="startcraft()">
            <svg xmlns="http://www.w3.org/2000/svg" height="20" width="15" viewBox="0 0 384 512"><!--!Font Awesome Free 6.7.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path fill="#63E6BE" d="M73 39c-14.8-9.1-33.4-9.4-48.5-.9S0 62.6 0 80L0 432c0 17.4 9.4 33.4 24.5 41.9s33.7 8.1 48.5-.9L361 297c14.3-8.7 23-24.2 23-41s-8.7-32.2-23-41L73 39z"/></svg>
        </div>
        <div class="cancelcraft" id="cancelcraft" onclick="cancelcraft()">
            <svg xmlns="http://www.w3.org/2000/svg" height="20" width="15" viewBox="0 0 384 512"><!--!Font Awesome Free 6.7.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path fill="#dd0865" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"/></svg>
        </div>
    `

    $("body .contentrecipe .actionscraft").html(htmlActionsCraft)
    document.getElementById("inpcountcraft").value = countCraft

}

// startcraft

function startcraft(){
    countCraft = document.getElementById("inpcountcraft").value
    let data = {
        datarecipe: datarecipe,
        countCraft: countCraft,
        indexs: indexs,
    }
    if (countCraft > 0){
        $.post(`https://${GetParentResourceName()}/startcraft`, JSON.stringify(data))
        loadbarredefil()
    } else {
        console.log('countcraft must be > 0')
        let datam = {
            type: "error",
            msg: "la valeur doit être suéprieure à 0",
            timer: 2000,
        }
        notif(datam)
    }
}

// cancelcraft

function cancelcraft(){
    hideUi()
    let datam = {
        type: "info",
        msg: "Craft annulé",
        timer: 2000,
    }
    notif(datam)
}

// barre

function loadbarredefil(){
    closerecipes()
    closerecipe()
    $("body .barredefil").css("display","flex")
    $("body .barredefil").html("")
    htmlBarredefil = ``
    htmlBarredefil += `
        <div class="title" id="title">
            ${datarecipe.labelitemfinal}
        </div>
        <div class="contentdefil" id="contentdefil">
            <div class="itemfinal">
                <div class="boximg">
                    <img src="${imgpath}${datarecipe.itemfinal}.png" />
                </div>
            </div>
            <div class="progressbar" id="progressbar">
                <div class="inprogress" id="inprogress">
                    Progression en cours...
                </div>
                <div class="barre" id="barre">
                    <div class="inbarre" id="inbarre"></div>
                </div>
                <div class="cancel" id="cancel" onclick="cancelcraft()">
                    <svg xmlns="http://www.w3.org/2000/svg" height="20" width="15" viewBox="0 0 384 512"><!--!Font Awesome Free 6.7.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path fill="#dd0865" d="M342.6 150.6c12.5-12.5 12.5-32.8 0-45.3s-32.8-12.5-45.3 0L192 210.7 86.6 105.4c-12.5-12.5-32.8-12.5-45.3 0s-12.5 32.8 0 45.3L146.7 256 41.4 361.4c-12.5 12.5-12.5 32.8 0 45.3s32.8 12.5 45.3 0L192 301.3 297.4 406.6c12.5 12.5 32.8 12.5 45.3 0s12.5-32.8 0-45.3L237.3 256 342.6 150.6z"/></svg>
                </div>
            </div>
        </div>
    `

    $("body .barredefil").html(htmlBarredefil)

    tick = 100 / countCraft
}


// functions notif

function notif(datamsg){
    $.post(`https://${GetParentResourceName()}/notifjs`, JSON.stringify({datamsg: datamsg}))
}

// functions base

window.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        hideUi()
    }
})

function hideUi() {    
    $("body").css("display", "none")
    $.post(`https://${GetParentResourceName()}/closeUI`, JSON.stringify({}))
}