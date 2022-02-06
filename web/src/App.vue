<template>
  <div
    v-if="multicharacter.activated"
    class="w-full h-full grid grid-col-3 gap-6 grid-cols-4 grid-rows-6"
  >
    <div
      class="flex flex-col items-start justify-center px-1 rounded col-span-4 font-spline font-bold ml-16 mr-16 border-b-2 border-white text-shadow-black"
    >
      <span class="text-5xl text-white mb-2 drop-shadow-lg"
        >Choose your character</span
      >
      <span class="text-xl text-gray-400 font-medium drop-shadow-lg"
        >Select a card and press the button under your character:</span
      >
    </div>
    <CharBox
      v-for="(char, index) in multicharacter.chars"
      :key="index"
      :char_id="char.character_id || char"
      :char_data="char"
      :char_elem_id="'char_' + index"
      class="mb-8 ml-16"
      @click="setSelected(index)"
      @delete-selected="deleteSelected"
    ></CharBox>
    <div
      class="flex flex-col items-center justify-between rounded row-span-5 mb-8"
    >
      <div class="w-full h-full"></div>
      <button
        ref="creation"
        @click="checkCharacter"
        style="background-color: #113a57"
        class="w-4/6 h-16 rounded bg-shale-600 font-spline text-white text-shadow-black drop-shadow-lg text-xl font-semibold transform hover:scale-105 duration-200"
      >
        {{ multicharacter.charSelection }}
      </button>
    </div>
  </div>
</template>

<script>
import "./assets/tailwind.css";
import fetchNui from "./utils/fetchNui";
import CharBox from "./components/CharBox";

export default {
  name: "App",
  components: {
    CharBox,
  },
  data() {
    return {
      multicharacter: {
        activated: true,
        data: null,
        chars: [],
        charSelection: "Choose a Slot",
        selected: null,
      },
    };
  },
  methods: {
    messageHandler(e) {
      switch (e.data.action) {
        case "startMulticharacter":
          for (let i = 0; i < e.data.identity.MaxSlots; i++) {
            if (e.data.playerData[i]) {
              const test = {
                character_id: e.data.playerData[i].character_id,
                firstName: "John",
                lastName: "Doe",
                dob: "01/01/2000",
                sex: "Male",
                accounts: {
                  money: 1500,
                  bank: 1500,
                  black: 1500,
                  tebex: 0,
                },
                jobs: {
                  jobName: "Police",
                  jobGrade: "Chief",
                  job2Name: "Mechanic",
                  job2Grade: "Recruit",
                },
              };
              this.multicharacter.chars.push(test);
              continue;
            }

            if (i >= e.data.identity.AllowedSlots) {
              this.multicharacter.chars.push({
                character_id: "blocked",
              });
              continue;
            }

            if (!e.data.playerData[i]) {
              this.multicharacter.chars.push({
                character_id: "create",
              });
              continue;
            }
          }
          this.multicharacter.activated = true;
          break;
        case "endMulticharacter":
          this.multicharacter.activated = false;
          this.multicharacter.chars.length = 0;
          break;
      }
    },
    checkCharacter() {
      if (this.multicharacter.data === "create") {
        fetchNui("create_character").then((resp) => {
          if (resp.done) {
            this.clearData();
          } else {
            console.log(
              "Error: Could not create character. Data was not received"
            );
          }
        });
      } else if (this.multicharacter.data !== null) {
        fetchNui("select_character", {
          character_id: this.multicharacter.data,
        }).then((resp) => {
          if (resp.done) {
            this.clearData();
          } else {
            console.log(
              "Error: Could not select character. Data was not received"
            );
          }
        });
      }
    },
    deleteSelected(data) {
      fetchNui("delete_character", { character_id: data }).then((resp) => {
        if (resp.done) {
          this.clearData();
        } else {
          console.log(
            "Error: Could not delete character. Data was not received"
          );
        }
      });
    },
    clearData() {
      this.multicharacter.activated = false;
      this.multicharacter.data = null;
      this.multicharacter.charSelection = "Choose a Slot";
      this.multicharacter.chars.length = 0;
      this.multicharacter.selected = null;
    },
    setSelected(key) {
      const target = document.getElementById(`char_${key}`);
      if (this.$refs.creation.disabled) {
        this.$refs.creation.style.backgroundColor = "#113A57";
        this.$refs.creation.disabled = false;
      }

      if (this.selected) {
        this.selected.classList.remove("ring-4", "ring-sky-600");
        this.selected.classList.add("border-b-4", "border-r-4");
        if (this.selected === target) {
          this.multicharacter.charSelection = "Choose a Slot";
          this.selected = null;
          return;
        }
      }
      this.selected = target;
      target.classList.add("ring-4", "ring-sky-600");
      this.selected.classList.remove("border-b-4", "border-r-4");
      switch (target.getAttribute("data-char-id")) {
        case "create":
          this.multicharacter.charSelection = "Create Character";
          this.multicharacter.data = "create";
          break;
        case "blocked":
          target.classList.add("ring-4", "ring-red-600");
          this.multicharacter.charSelection = "Blocked Character";
          this.$refs.creation.style.backgroundColor = "#d52b2b";
          this.$refs.creation.disabled = true;
          this.multicharacter.data = null;
          return;
        default:
          this.multicharacter.data = parseInt(
            target.getAttribute("data-char-id")
          );
          this.multicharacter.charSelection = "Select Character";
          break;
      }
      target.classList.add("ring-4", "ring-sky-600");
    },
  },
  mounted() {
    const test = {
      character_id: 15,
      firstName: "John",
      lastName: "Doe",
      dob: "01/01/2000",
      sex: "Male",
      accounts: {
        money: 1500,
        bank: 1500,
        black: 1500,
        tebex: 0,
      },
      jobs: {
        jobName: "Police",
        jobGrade: "Chief",
        job2Name: "Mechanic",
        job2Grade: "Recruit",
      },
    };
    this.multicharacter.chars.push(test);
    console.log("mounted");
    window.addEventListener("message", this.messageHandler);
  },
  unmounted() {
    window.removeEventListener("message", this.messageHandler);
  },
};
</script>

<style>
@import url("https://fonts.googleapis.com/css2?family=Spline+Sans:wght@400;500;600;700&display=swap");

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
    "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  height: 100vh;
}

.text-shadow-black {
  text-shadow: 2px 1px black;
}

.slide-fade-enter-active {
  transition: opacity 1s;
}

.slide-fade-leave-active {
  transition: opacity 1s;
}

.slide-fade-enter-from,
.slide-fade-leave-to {
  opacity: 0;
}
</style>
