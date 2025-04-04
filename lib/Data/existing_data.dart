// To upload data in firebase
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadQuestionsToFirebase() async {
  for (final sector in data.entries) {
    uploadFieldQuestions(sector.key, sector.value);
  }
}

Future<void> uploadFieldQuestions(String field, dynamic data) async {
  FirebaseFirestore.instance.collection('questions').doc(field).set(data);
}

final data = {
  "Mathematics": {
    "title": "Mathematics",
    "image_url": "https://img.freepik.com/free-photo/blackboard-inscribed-with-scientific-formulas-calculations_1150-19413.jpg?t=st=1742829717~exp=1742833317~hmac=6d0ee69fff67304a859c1dab898c1d85c2ba20d42cd799d80a22f42883adce5e&w=2000",
    "question": {
      "0": {
        "correctOptionKey": "4",
        "options": {
          "1": "2x + 3 = 7",
          "2": "y = mx + b",
          "3": "x^2 - 4 = 0",
          "4": "banana + 2 = 5"
        },
        "questionText": "Which of the following is NOT a valid algebraic equation?"
      },
      "1": {
        "correctOptionKey": "3",
        "options": {
          "1": "π ≈ 3.14",
          "2": "The square root of 4 is 2",
          "3": "The cube of 3 is 6",
          "4": "0 is an even number"
        },
        "questionText": "Which of the following is mathematically incorrect?"
      },
      "2": {
        "correctOptionKey": "2",
        "options": {
          "1": "Addition",
          "2": "Integration",
          "3": "Subtraction",
          "4": "Multiplication"
        },
        "questionText": "Which of the following operations is used in calculus but not typically in basic arithmetic?"
      },
      "3": {
        "correctOptionKey": "1",
        "options": {
          "1": "A triangle with sides 3, 4, 5",
          "2": "A triangle with sides 2, 2, 3",
          "3": "A triangle with all angles less than 90°",
          "4": "A triangle with two equal sides"
        },
        "questionText": "Which of the following is a right triangle?"
      },
      "4": {
        "correctOptionKey": "4",
        "options": {
          "1": "Mean",
          "2": "Median",
          "3": "Mode",
          "4": "Gravity"
        },
        "questionText": "Which of the following is NOT a measure of central tendency?"
      },
      "5": {
        "correctOptionKey": "1",
        "options": {
          "1": "3/0",
          "2": "0/3",
          "3": "3/1",
          "4": "0/1"
        },
        "questionText": "Which of the following is undefined in mathematics?"
      },
      "6": {
        "correctOptionKey": "2",
        "options": {
          "1": "Area of a circle",
          "2": "Volume of a cube",
          "3": "Perimeter of a square",
          "4": "Area of a triangle"
        },
        "questionText": "Which of the following involves three-dimensional measurement?"
      },
      "7": {
        "correctOptionKey": "3",
        "options": {
          "1": "f(x) = x^2",
          "2": "f(x) = 2x + 1",
          "3": "f(x) = x/0",
          "4": "f(x) = √x"
        },
        "questionText": "Which function is undefined for any input?"
      },
      "8": {
        "correctOptionKey": "2",
        "options": {
          "1": "90°",
          "2": "180°",
          "3": "360°",
          "4": "270°"
        },
        "questionText": "What is the sum of the interior angles of a triangle?"
      },
      "9": {
        "correctOptionKey": "4",
        "options": {
          "1": "Set",
          "2": "Function",
          "3": "Matrix",
          "4": "Forest"
        },
        "questionText": "Which of the following is NOT a mathematical concept?"
      }
    }
  },

  "Engineering": {
    "title": "Engineering",
    "image_url": "https://img.freepik.com/free-vector/bundle-engineering-set-icons_24877-57315.jpg?ga=GA1.1.222963692.1743719257&semt=ais_hybrid&w=740",
    "question": {
      "0": {
        "correctOptionKey": "4",
        "options": {
          "1": "Mechanical",
          "2": "Civil",
          "3": "Electrical",
          "4": "Origami"
        },
        "questionText": "Which of the following is NOT a branch of engineering?"
      },
      "1": {
        "correctOptionKey": "3",
        "options": {
          "1": "Blueprint",
          "2": "Prototype",
          "3": "Magic wand",
          "4": "CAD software"
        },
        "questionText": "Which of the following is NOT typically used in the engineering design process?"
      },
      "2": {
        "correctOptionKey": "1",
        "options": {
          "1": "Innovation",
          "2": "Gravity",
          "3": "Problem-solving",
          "4": "Design"
        },
        "questionText": "Which of the following is a key aspect of engineering?"
      },
      "3": {
        "correctOptionKey": "2",
        "options": {
          "1": "Torque",
          "2": "Photosynthesis",
          "3": "Load-bearing",
          "4": "Friction"
        },
        "questionText": "Which of the following is NOT a concept typically studied in engineering?"
      },
      "4": {
        "correctOptionKey": "3",
        "options": {
          "1": "Bridge construction",
          "2": "Circuit design",
          "3": "Storytelling",
          "4": "Software development"
        },
        "questionText": "Which of the following is NOT commonly associated with engineering work?"
      },
      "5": {
        "correctOptionKey": "1",
        "options": {
          "1": "Thermodynamics",
          "2": "Voltage",
          "3": "Stress and strain",
          "4": "Chemical reactions"
        },
        "questionText": "Which of the following is studied in mechanical engineering?"
      },
      "6": {
        "correctOptionKey": "4",
        "options": {
          "1": "Bridge",
          "2": "Engine",
          "3": "Skyscraper",
          "4": "Cupcake"
        },
        "questionText": "Which of the following is NOT an example of an engineering project?"
      },
      "7": {
        "correctOptionKey": "2",
        "options": {
          "1": "Electrical circuits",
          "2": "Astrology charts",
          "3": "Structural analysis",
          "4": "Fluid dynamics"
        },
        "questionText": "Which of the following is NOT related to engineering?"
      },
      "8": {
        "correctOptionKey": "3",
        "options": {
          "1": "Design",
          "2": "Test",
          "3": "Meditate",
          "4": "Build"
        },
        "questionText": "Which of the following is NOT typically part of the engineering process?"
      },
      "9": {
        "correctOptionKey": "1",
        "options": {
          "1": "Safety",
          "2": "Precision",
          "3": "Efficiency",
          "4": "Fortune-telling"
        },
        "questionText": "Which of the following is MOST important in engineering design?"
      }
    }
  },

  "Science": {
    "title": "Science",
    "image_url": "https://img.freepik.com/free-vector/hand-drawn-science-education-background_23-2148499325.jpg?t=st=1742829765~exp=1742833365~hmac=19fbe0d6095234b2ad8c8d876756f46d1c2b7a2696454a427621aac807811200&w=2000",
    "question": {
      "0": {
        "correctOptionKey": "2",
        "options": {
          "1": "Evaporation",
          "2": "Combustion",
          "3": "Condensation",
          "4": "Freezing"
        },
        "questionText": "Which of the following is a chemical change?"
      },
      "1": {
        "correctOptionKey": "4",
        "options": {
          "1": "Proton",
          "2": "Electron",
          "3": "Neutron",
          "4": "Photon"
        },
        "questionText": "Which of the following is NOT a subatomic particle found in the nucleus of an atom?"
      },
      "2": {
        "correctOptionKey": "1",
        "options": {
          "1": "Mitochondria",
          "2": "Nucleus",
          "3": "Ribosome",
          "4": "Chloroplast"
        },
        "questionText": "Which organelle is known as the powerhouse of the cell?"
      },
      "3": {
        "correctOptionKey": "3",
        "options": {
          "1": "Gravity",
          "2": "Friction",
          "3": "Love",
          "4": "Magnetism"
        },
        "questionText": "Which of the following is NOT a recognized scientific force?"
      },
      "4": {
        "correctOptionKey": "2",
        "options": {
          "1": "Water boils at 100°C",
          "2": "The moon is made of cheese",
          "3": "The Earth orbits the Sun",
          "4": "Light travels faster than sound"
        },
        "questionText": "Which of the following statements is scientifically incorrect?"
      },
      "5": {
        "correctOptionKey": "1",
        "options": {
          "1": "Photosynthesis",
          "2": "Respiration",
          "3": "Fermentation",
          "4": "Digestion"
        },
        "questionText": "Which process allows plants to convert sunlight into energy?"
      },
      "6": {
        "correctOptionKey": "4",
        "options": {
          "1": "Mercury",
          "2": "Venus",
          "3": "Earth",
          "4": "Pluto"
        },
        "questionText": "Which of the following is NOT officially classified as a planet in our solar system?"
      },
      "7": {
        "correctOptionKey": "2",
        "options": {
          "1": "Solid",
          "2": "Plasma",
          "3": "Liquid",
          "4": "Gas"
        },
        "questionText": "Which state of matter is made up of ionized particles and found in stars?"
      },
      "8": {
        "correctOptionKey": "3",
        "options": {
          "1": "Carbon",
          "2": "Nitrogen",
          "3": "Helium",
          "4": "Oxygen"
        },
        "questionText": "Which gas is used in balloons because it is lighter than air and non-flammable?"
      },
      "9": {
        "correctOptionKey": "1",
        "options": {
          "1": "Einstein",
          "2": "Newton",
          "3": "Galileo",
          "4": "Curie"
        },
        "questionText": "Who developed the theory of relativity?"
      }
    }
  },

  "Social Studies": {
    "title": "Social Studies",
    "image_url": "https://img.freepik.com/free-vector/geopraphy-concept-with-retro-cartoon-school-lesson-set_1284-7502.jpg?ga=GA1.1.222963692.1743719257&semt=ais_hybrid&w=740",
    "question": {
      "0": {
        "correctOptionKey": "2",
        "options": {
          "1": "Democracy",
          "2": "Hydrogen bonding",
          "3": "Monarchy",
          "4": "Dictatorship"
        },
        "questionText": "Which of the following is NOT a form of government?"
      },
      "1": {
        "correctOptionKey": "4",
        "options": {
          "1": "Voting",
          "2": "Paying taxes",
          "3": "Following laws",
          "4": "Telepathy"
        },
        "questionText": "Which of the following is NOT a civic duty?"
      },
      "2": {
        "correctOptionKey": "1",
        "options": {
          "1": "The study of human society",
          "2": "The study of rocks and minerals",
          "3": "The study of living organisms",
          "4": "The study of chemical elements"
        },
        "questionText": "What is social studies primarily concerned with?"
      },
      "3": {
        "correctOptionKey": "3",
        "options": {
          "1": "Legislative",
          "2": "Judicial",
          "3": "Muscular",
          "4": "Executive"
        },
        "questionText": "Which of the following is NOT a branch of government?"
      },
      "4": {
        "correctOptionKey": "4",
        "options": {
          "1": "Geography",
          "2": "History",
          "3": "Civics",
          "4": "Quantum physics"
        },
        "questionText": "Which of the following is NOT a major area of study within social studies?"
      },
      "5": {
        "correctOptionKey": "2",
        "options": {
          "1": "Culture",
          "2": "Photosynthesis",
          "3": "Economics",
          "4": "Government"
        },
        "questionText": "Which of the following is NOT typically associated with social studies?"
      },
      "6": {
        "correctOptionKey": "1",
        "options": {
          "1": "United Nations",
          "2": "City council",
          "3": "School board",
          "4": "Senate"
        },
        "questionText": "Which international organization promotes global peace and cooperation?"
      },
      "7": {
        "correctOptionKey": "3",
        "options": {
          "1": "Latitude",
          "2": "Longitude",
          "3": "Thermodynamics",
          "4": "Hemisphere"
        },
        "questionText": "Which of the following is NOT a geographic concept?"
      },
      "8": {
        "correctOptionKey": "4",
        "options": {
          "1": "American Revolution",
          "2": "World War II",
          "3": "Civil Rights Movement",
          "4": "Video game update"
        },
        "questionText": "Which of the following is NOT a historical event studied in social studies?"
      },
      "9": {
        "correctOptionKey": "2",
        "options": {
          "1": "Citizenship",
          "2": "Photoshop skills",
          "3": "Community involvement",
          "4": "Rule of law"
        },
        "questionText": "Which of the following is NOT a concept typically emphasized in civics education?"
      }
    }
  },

  "Economics": {
    "title": "Economics",
    "image_url": "https://img.freepik.com/free-vector/economic-growth_24877-49241.jpg?t=st=1742829891~exp=1742833491~hmac=0d53498aa637a9366ce1779d2e3584f8aea820dea79ec3000ade2c2eba5cb004&w=1380",
    "question": {
      "0": {
        "correctOptionKey": "4",
        "options": {
          "1": "Supply",
          "2": "Demand",
          "3": "Equilibrium",
          "4": "Photosynthesis"
        },
        "questionText": "Which of the following is NOT an economic concept?"
      },
      "1": {
        "correctOptionKey": "2",
        "options": {
          "1": "Scarcity",
          "2": "Abundance of unlimited resources",
          "3": "Opportunity cost",
          "4": "Trade-offs"
        },
        "questionText": "Which of the following contradicts a basic principle of economics?"
      },
      "2": {
        "correctOptionKey": "3",
        "options": {
          "1": "Capital",
          "2": "Labor",
          "3": "Oxygen",
          "4": "Land"
        },
        "questionText": "Which of the following is NOT considered a factor of production in economics?"
      },
      "3": {
        "correctOptionKey": "1",
        "options": {
          "1": "Inflation",
          "2": "Interest rates",
          "3": "Unemployment",
          "4": "Baking soda"
        },
        "questionText": "Which of the following measures the general increase in prices over time?"
      },
      "4": {
        "correctOptionKey": "4",
        "options": {
          "1": "Microeconomics",
          "2": "Macroeconomics",
          "3": "Behavioral economics",
          "4": "Astrophysics"
        },
        "questionText": "Which of the following is NOT a branch of economics?"
      },
      "5": {
        "correctOptionKey": "1",
        "options": {
          "1": "Gross Domestic Product (GDP)",
          "2": "Net Present Value",
          "3": "Return on Investment (ROI)",
          "4": "Compound Interest"
        },
        "questionText": "Which metric is used to measure the total value of goods and services produced in a country?"
      },
      "6": {
        "correctOptionKey": "3",
        "options": {
          "1": "Monopoly",
          "2": "Oligopoly",
          "3": "Utopia",
          "4": "Perfect competition"
        },
        "questionText": "Which of the following is NOT a type of market structure in economics?"
      },
      "7": {
        "correctOptionKey": "2",
        "options": {
          "1": "Subsidy",
          "2": "Lightning",
          "3": "Tax",
          "4": "Tariff"
        },
        "questionText": "Which of the following is NOT a fiscal tool used by governments?"
      },
      "8": {
        "correctOptionKey": "4",
        "options": {
          "1": "Federal Reserve",
          "2": "Central Bank",
          "3": "International Monetary Fund",
          "4": "Spotify"
        },
        "questionText": "Which of the following is NOT an economic institution?"
      },
      "9": {
        "correctOptionKey": "1",
        "options": {
          "1": "Supply increases, price decreases",
          "2": "Supply decreases, price decreases",
          "3": "Demand increases, price decreases",
          "4": "Demand remains the same, price decreases"
        },
        "questionText": "According to the law of supply and demand, what typically happens when supply increases and demand stays constant?"
      }
    }
  },

  "Business": {
    "title": "Business",
    "image_url": "https://img.freepik.com/free-photo/group-diverse-people-having-business-meeting_53876-25060.jpg?ga=GA1.1.222963692.1743719257&semt=ais_hybrid&w=740",
    "question": {
      "0": {
        "correctOptionKey": "3",
        "options": {
          "1": "Revenue",
          "2": "Profit",
          "3": "Chlorophyll",
          "4": "Expense"
        },
        "questionText": "Which of the following is NOT a common business term?"
      },
      "1": {
        "correctOptionKey": "4",
        "options": {
          "1": "Sole proprietorship",
          "2": "Partnership",
          "3": "Corporation",
          "4": "Hurricane"
        },
        "questionText": "Which of the following is NOT a type of business ownership?"
      },
      "2": {
        "correctOptionKey": "2",
        "options": {
          "1": "Marketing",
          "2": "Photosynthesis",
          "3": "Finance",
          "4": "Operations"
        },
        "questionText": "Which of the following is NOT a function of business?"
      },
      "3": {
        "correctOptionKey": "1",
        "options": {
          "1": "Entrepreneur",
          "2": "Employee",
          "3": "Manager",
          "4": "Supervisor"
        },
        "questionText": "What do you call someone who starts their own business?"
      },
      "4": {
        "correctOptionKey": "4",
        "options": {
          "1": "SWOT analysis",
          "2": "Business plan",
          "3": "Marketing strategy",
          "4": "Photoshop filter"
        },
        "questionText": "Which of the following is NOT typically found in a business strategy document?"
      },
      "5": {
        "correctOptionKey": "2",
        "options": {
          "1": "Target market",
          "2": "Lunar eclipse",
          "3": "Branding",
          "4": "Customer satisfaction"
        },
        "questionText": "Which of the following is NOT directly related to business marketing?"
      },
      "6": {
        "correctOptionKey": "3",
        "options": {
          "1": "Assets",
          "2": "Liabilities",
          "3": "Penguins",
          "4": "Equity"
        },
        "questionText": "Which of the following is NOT a component of a balance sheet?"
      },
      "7": {
        "correctOptionKey": "4",
        "options": {
          "1": "Mission statement",
          "2": "Vision statement",
          "3": "Core values",
          "4": "Song lyrics"
        },
        "questionText": "Which of the following is NOT typically part of a company’s foundational documents?"
      },
      "8": {
        "correctOptionKey": "1",
        "options": {
          "1": "Cash flow",
          "2": "Revenue",
          "3": "Profit",
          "4": "Gravity"
        },
        "questionText": "Which of the following measures the amount of money moving in and out of a business?"
      },
      "9": {
        "correctOptionKey": "2",
        "options": {
          "1": "Market research",
          "2": "Volcano eruption",
          "3": "Customer feedback",
          "4": "Competitive analysis"
        },
        "questionText": "Which of the following is NOT part of a typical business market analysis?"
      }
    }
  },

  "Languages": {
    "title": "Languages",
    "image_url": "https://img.freepik.com/free-vector/flat-international-mother-language-day-illustration_23-2149219243.jpg?ga=GA1.1.222963692.1743719257&semt=ais_hybrid&w=740",
    "question": {
      "0": {
        "correctOptionKey": "3",
        "options": {
          "1": "Spanish",
          "2": "Mandarin",
          "3": "Gravity",
          "4": "French"
        },
        "questionText": "Which of the following is NOT a spoken language?"
      },
      "1": {
        "correctOptionKey": "4",
        "options": {
          "1": "Verb",
          "2": "Noun",
          "3": "Adjective",
          "4": "Telescope"
        },
        "questionText": "Which of the following is NOT a part of speech?"
      },
      "2": {
        "correctOptionKey": "1",
        "options": {
          "1": "Grammar",
          "2": "Quantum mechanics",
          "3": "Vocabulary",
          "4": "Pronunciation"
        },
        "questionText": "Which of the following is an essential component of language learning?"
      },
      "3": {
        "correctOptionKey": "2",
        "options": {
          "1": "Arabic",
          "2": "HTML",
          "3": "German",
          "4": "Japanese"
        },
        "questionText": "Which of the following is NOT a natural human language?"
      },
      "4": {
        "correctOptionKey": "3",
        "options": {
          "1": "English",
          "2": "Italian",
          "3": "Algorithm",
          "4": "Portuguese"
        },
        "questionText": "Which of the following is NOT a Romance language?"
      },
      "5": {
        "correctOptionKey": "4",
        "options": {
          "1": "Syntax",
          "2": "Sentence structure",
          "3": "Context",
          "4": "Astrology"
        },
        "questionText": "Which of the following is NOT related to language structure?"
      },
      "6": {
        "correctOptionKey": "2",
        "options": {
          "1": "Duolingo",
          "2": "Stethoscope",
          "3": "Flashcards",
          "4": "Language exchange"
        },
        "questionText": "Which of the following is NOT typically used in language learning?"
      },
      "7": {
        "correctOptionKey": "1",
        "options": {
          "1": "Translation",
          "2": "Chemistry",
          "3": "Interpretation",
          "4": "Bilingualism"
        },
        "questionText": "Which of the following involves converting written text from one language to another?"
      },
      "8": {
        "correctOptionKey": "3",
        "options": {
          "1": "Tone",
          "2": "Accent",
          "3": "Magnetism",
          "4": "Dialect"
        },
        "questionText": "Which of the following is NOT related to spoken language variation?"
      },
      "9": {
        "correctOptionKey": "4",
        "options": {
          "1": "Reading",
          "2": "Writing",
          "3": "Speaking",
          "4": "Teleporting"
        },
        "questionText": "Which of the following is NOT a skill practiced when learning a new language?"
      }
    }
  }
};