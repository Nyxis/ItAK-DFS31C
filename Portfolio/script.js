tailwind.config = {
  darkMode: "class",
  theme: {
    extend: {
      backgroundColor: {
        dark: "black",
      },
      colors: {
        transparent: "transparent",
        current: "currentColor",
        white: "#ffffff",
        purple: "#3f3cbb",
        midnight: "#121063",
        bleu: "#3ab7bf",
        silver: "#ecebff",
        bubblegum: "#ff77e9",
        bermuda: "#78dcca",
      },
    },
  },
};

document.addEventListener("DOMContentLoaded", function () {
  document
    .querySelector(".theme-controller")
    .addEventListener("change", function () {
      if (this.checked) {
        document.documentElement.classList.add("dark");
        document.documentElement.setAttribute("data-theme", "black");
      } else {
        document.documentElement.classList.remove("dark");
        document.documentElement.setAttribute("data-theme", "light");
      }
    });
});


const Competences = [
  {
    category: "Front-end",
    skills: ["html.svg", "Css.svg", "Javascript.svg", "Tailwind.svg","React.svg"],
  },
  {
    category: "Back-end",
    skills: ["Express-js.svg", "NodeJs.svg","Php.svg"],
  },
  {
    category: "Database",
    skills: ["mysql.svg"],
  },
  {
    category: "Divers",
    skills: ["github-brands-solid.svg", "Figma.svg", "Jira.svg"],
  },
];

// Fonction pour générer la FAQ


function GenererCompetences() {
  const skillsContainer = document.getElementById("skills-container");
  skillsContainer.innerHTML = `
    <h2 class="text-3xl font-bold  text-center mb-12 text-black dark:text-slate-50">
      Mes compétences techniques
    </h2>
    <div class="flex flex-wrap justify-center -mx-2">
      ${Competences.map(
        (category) => `
        <div class="w-full md:w-1/2 px-2 mb-4">
          <div class="card bg-base-100 h-full">
            <div class="card-body rounded-xl border shadow-md shadow-black  dark:shadow-lg  dark:shadow-blue-400 border-black dark:border-white ">
              <h3 class="card-title mb-4 font-bold dark:text-slate-50">${
                category.category
              }</h3>
              <div class="flex flex-wrap gap-4">
                ${category.skills
                  .map(
                    (skill) => `
                  <img class="w-10 dark:invert" src="images/${skill}" alt="${
                      skill.split(".")[0]
                    }">
                `
                  )
                  .join("")}
              </div>
            </div>
          </div>
        </div>
      `
      ).join("")}
    </div>
  `;
}

document.addEventListener("DOMContentLoaded", () => {
  GenererCompetences();
  AOS.init();
});
