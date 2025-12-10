// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "../stylesheets/application"; 

Rails.start()
Turbolinks.start()
ActiveStorage.start()


import jquery from 'jquery'
window.$ = window.jQuery = jquery;
import "bootstrap";

import Raty from "raty-js";

const initRaty = () => {
  console.log("★ Raty処理開始: ページ読み込み完了");

  const formElem = document.querySelector('#post_raty');
  
  if (formElem && formElem.children.length === 0) {
    console.log("★ フォーム要素を発見。Ratyを初期化します。");
    
    const raty = new Raty(formElem, {
      starOn:    formElem.dataset.starOn,
      starOff:   formElem.dataset.starOff,
      scoreName: formElem.dataset.scoreName, 
      number:    5,
    });
    raty.init();
  }

  const showElems = document.querySelectorAll('.raty-show');

  showElems.forEach((elem) => {
    if (elem.children.length === 0) {
      const raty = new Raty(elem, {
        starOn:   elem.dataset.starOn,
        starOff:  elem.dataset.starOff,
        score:    elem.dataset.score,
        readOnly: true,
        number:   5,
      });
      raty.init();
    }
  });
};

window.addEventListener("turbolinks:load", initRaty);
window.addEventListener("load", initRaty); // 強制実行