let texte = document.querySelector(".js-texte");
let email = document.querySelector(".js-email");
let message = document.querySelector(".js-message");
let nom = document.querySelector(".js-nom");
let bouton = document.querySelector(".js-bouton");

const emailRegex =
  /^[a-zA-Z0-9][a-zA-Z0-9!#$%&'*+\-/=?^_`{|}~]*[a-zA-Z0-9]@[a-zA-Z0-9]+\.[a-zA-Z]+$/;

bouton.addEventListener("click", function () {
  if (
    email.value === "" ||
    message.value === "" ||
    nom.value === "" ||
    !emailRegex.test(email.value)
  ) {
    texte.innerHTML = "Rentrez vos informations avant de valider !";
    texte.classList.add("text-red-500", "font-bold");
    if (email.value !== "" && !emailRegex.test(email.value)) {
      texte.innerHTML = "Veuillez entrer une adresse email valide.";
    }
    setTimeout(function () {
      texte.innerHTML = "";
    }, 4500);
  } else {
    texte.innerHTML = "Merci pour votre confiance.";
    texte.classList.remove("text-red-500", "font-bold");
    texte.classList.add("text-green-500", "font-bold");
    setTimeout(function () {
      texte.innerHTML = "";
    }, 3000);
  }
});
