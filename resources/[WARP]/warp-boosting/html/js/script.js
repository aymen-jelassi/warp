const showBoostList = (carName, carModel, boostClass) => {
  const li = `
  <li class="boostListItem">
  <p style="margin-bottom: 10px">Vehicle: ${carName}</h5>
  <p style="margin-bottom: 10px">Contract Type: ${boostClass}</p>
  <p>Owner: warp</p>
  <div class="boost-list-btns">
    <button id="boostAccept" class="waves-effect waves-light btn green darken-1" carModel="${carModel}" carName="${carName}" boostClass="${boostClass}">Accept Boost </button>
    <button class="waves-effect waves-light btn red darken-1" id='boostDecline'>
      Decline Boost
    </button>
  </div>
  </li>
  `;
  $("#carBoostList").append(li);
};

$(function () {
  function display(bool) {
    if (bool) {
      $("#container").show();
      $.post("https://warp-boosting/getXp", JSON.stringify({}));
    } else {
      $("#container").hide();
    }
  }

  window.addEventListener("message", function (e) {
    let data = e.data;
    if (data.type === "ui") {
      if (data.status === true) {
        display(true);
        $("#date").html(data.date);
        $("#time").html(data.time);
      } else {
        display(false);
      }
    }
    if (data.isBoostReady === true) {
      showBoostList(data.carName, data.carModel, data.boostClass);
    }
    if (data.type === "xpCheck") {
      setXpBar(data.xp);
      setLevelStr(data.level);
    }
    if (data.type === "complete") {
      $("#boostInProgress").hide();
      $("#boostAppMain").show();
      isBoostActive = false;
    }
  });

  const setLevelStr = (level) => {
    if (level === 1) {
      $("#levelleft").html("D");
      $("#levelright").html("C");
    } else if (level === 2) {
      $("#levelleft").html("C");
      $("#levelright").html("B");
    } else if (level === 3) {
      $("#levelleft").html("B");
      $("#levelright").html("A");
    } else if (level === 4) {
      $("#levelleft").html("A");
      $("#levelright").html("S");
    } else if (level === 5) {
      $("#levelleft").html("S");
      $("#levelright").html("S");
    }
  };

  const setXpBar = (xp) => {
    let widthNum = xp > 100 ? 100 : xp;
    let width = widthNum.toString() + "%";

    $("#myBar").css("width", width);
  };

  display(false);
  $("#boostingApp").hide();
  $("#loading").hide();
  $("#boostAppMain").hide();
  $("#boostInProgress").hide();
  $("#confirmDeclineModal").hide();
  $("#leaveQueueBtn").hide();

  document.onkeyup = function (data) {
    if (data.which == 27) {
      $.post("https://warp-boosting/close", JSON.stringify({}));
    }
  };

  let isLoggedIn = false;
  let isBoostActive = false;
  let isInQueue = false;

  $("#openBoostApp").click(function () {
    $("#boostingApp").show();
    if (!isLoggedIn) {
      $("#boostAppMain").show();
      $("#boostAppMain").hide();
    } else {
      $("#boostAppMain").show();
    }

    if (isLoggedIn) {
      $("#boostAppMain").show();
      $("#boostInProgress").hide();
    } else if (!isLoggedIn) {
      $("#boostAppMain").show();
      $("#boostInProgress").hide();
    } else if (isBoostActive && isLoggedIn) {
      $("#boostInProgress").show();
      $("#boostAppMain").hide();
    }
  });

  $("#loginBtn").click(function () {
    $("#boostAppMain").show();
    isLoggedIn = true;
  });

  $("#closeBoostApp").click(function () {
    $("#boostingApp").hide();
  });

  $("#queueBtn").click(function () {
    if (isInQueue === false) {
      $("#loading").show();
      $("#queueBtn").hide();
      setTimeout(() => {
        $.post("https://warp-boosting/joinBoostQueue"), JSON.stringify({});
        $("#leaveQueueBtn").show();
        $("#loading").hide();
        isInQueue = true;
      }, 1000);
    }
  });

  $("#leaveQueueBtn").click(function () {
    if (isInQueue === true) {
      $("#loading").show();
      $("#leaveQueueBtn").hide();
      setTimeout(() => {
        $.post("https://warp-boosting/leaveBoostQueue"), JSON.stringify({});
        $("#queueBtn").show();
        $("#loading").hide();
        isInQueue = false;
      }, 1000);
    }
  });

  $(document).on("click", "#boostAccept", function () {
    const carModel = $(this).attr("carModel");
    const carName = $(this).attr("carName");
    const carClass = $(this).attr("boostClass");

    $.post(
      "https://warp-boosting/startBoost",
      JSON.stringify({
        carName: carName,
        carModel: carModel,
        carClass: carClass,
      })
    );
    $(this).closest(".boostListItem").remove();
    $("#boostCarName").text(carName);
    $("#boostAppMain").hide();
    $("#boostInProgress").show();
    $.post("https://warp-boosting/leaveBoostQueue"), JSON.stringify({});
    $("#queueBtn").show();
    $("#leaveQueueBtn").hide();
    $("#loading").hide();
    isInQueue = false;
    isBoostActive = true;

    // $.post("https://warp-boosting/close", JSON.stringify({}));
  });

  let liTargetDel = null;

  $(document).on("click", "#boostDecline", function () {
    liTargetDel = $(this).closest(".boostListItem");
    $("#confirmDeclineModal").show();
    $("#boostAppMain").hide();
  });

  $("#boostDeclineConfirm").click(function () {
    liTargetDel.remove();
    $("#confirmDeclineModal").hide();
    $("#boostAppMain").show();
  });

  $("#boostDeclineNo").click(function () {
    $("#confirmDeclineModal").hide();
    $("#boostAppMain").show();
  });

  $("#cancelBoost").click(function () {
    $.post("https://warp-boosting/cancelContract", JSON.stringify({}));
    $("#boostAppMain").show();
    $("#boostInProgress").hide();
    isBoostActive = false;
    // ALSO LOSE XP?
  });
});