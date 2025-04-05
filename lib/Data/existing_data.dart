/* lib/Data/existing_data.dart */

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
    "courses": {
      "Algebra 1": {
        "image_url": "https://img.freepik.com/free-vector/happy-students-learning-math-college-school-isolated-flat-illustration_74855-10799.jpg?t=st=1743803894~exp=1743807494~hmac=386aca8ddd97248d92d49248016498daca23b1070ec8c204cbdccd10a1c063be&w=2000",
        "lessons": {
          "lesson1": {
            "title": "1. Introduction to Algebra",
            "content": "Overview of algebraic expressions, variables, and constants."
          },
          "lesson2": {
            "title": "2. Linear Equations",
            "content": "Learn how to solve and graph linear equations."
          },
        },
        "quiz": {
          "0": {
            "questionText": "Which equation is linear?",
            "options": {
              "1": "y = 2x + 1",
              "2": "x^2 + 3",
              "3": "x^3 - 2",
              "4": "sin(x)"
            },
            "correctOptionKey": "1"
          },
          "1": {
            "questionText": "What is the value of x in 2x = 6?",
            "options": {
              "1": "4",
              "2": "5",
              "3": "3",
              "4": "7"
            },
            "correctOptionKey": "3"
          },
          "2": {
            "questionText": "Solve for x: x + 5 = 10",
            "options": {
              "1": "3",
              "2": "4",
              "3": "5",
              "4": "6"
            },
            "correctOptionKey": "3"
          }
        }
      },
      "Algebra 2": {
        "image_url": "https://img.freepik.com/free-photo/numerology-concept-composition_23-2150169791.jpg?t=st=1743803947~exp=1743807547~hmac=9d3275d79f9360b79ed9fc61662a8b0a44912dda654c6e95d81dd7507cc9e98e&w=2000",
        "lessons": {
          "lesson1": {
            "title": "1. Advanced Algebra Introduction",
            "content": "Explore higher-level algebraic concepts and problem-solving techniques."
          },
          "lesson2": {
            "title": "2. Quadratic Equations",
            "content": "Learn to solve quadratic equations using various methods."
          },
        },
        "quiz": {
          "0": {
            "questionText": "What is the discriminant in a quadratic equation?",
            "options": {
              "1": "b^2 - 4ac",
              "2": "2a",
              "3": "4ac",
              "4": "b^2 + 4ac"
            },
            "correctOptionKey": "1"
          },
          "1": {
            "questionText": "Solve: x^2 - 5x + 6 = 0",
            "options": {
              "1": "x = 2 or 3",
              "2": "x = 1 or 6",
              "3": "x = 3 or 2",
              "4": "x = -2 or -3"
            },
            "correctOptionKey": "1"
          },
          "2": {
            "questionText": "Which formula is used to solve quadratic equations?",
            "options": {
              "1": "Quadratic formula",
              "2": "Cubic formula",
              "3": "Linear formula",
              "4": "Factorization"
            },
            "correctOptionKey": "1"
          }
        }
      }
    }
  },

  "Engineering": {
    "title": "Engineering",
    "image_url": "https://img.freepik.com/free-vector/bundle-engineering-set-icons_24877-57315.jpg?ga=GA1.1.222963692.1743719257&semt=ais_hybrid&w=740",
    "courses": {
      "Fundamentals of Engineering": {
        "image_url": "https://img.freepik.com/free-photo/still-life-business-roles-with-various-mechanism-pieces_23-2149352652.jpg?t=st=1743804015~exp=1743807615~hmac=345328842e1f95bcee937abfb49cf9e74299a5c26bbae88fd3db9313f3f91cab&w=2000",
        "lessons": {
          "lesson1": {
            "title": "1. Introduction to Engineering",
            "content": "Explore the different branches of engineering and their real-world applications."
          },
          "lesson2": {
            "title": "2. Engineering Design Process",
            "content": "Understand the steps involved in defining, planning, and developing engineering solutions."
          }
        },
        "quiz": {
          "0": {
            "questionText": "Which of the following is a step in the engineering design process?",
            "options": {
              "1": "Brainstorming",
              "2": "Guesswork",
              "3": "Randomization",
              "4": "Procrastination"
            },
            "correctOptionKey": "1"
          },
          "1": {
            "questionText": "Which branch of engineering deals with machinery and mechanical systems?",
            "options": {
              "1": "Civil Engineering",
              "2": "Mechanical Engineering",
              "3": "Electrical Engineering",
              "4": "Chemical Engineering"
            },
            "correctOptionKey": "2"
          },
          "2": {
            "questionText": "What is the first step in solving an engineering problem?",
            "options": {
              "1": "Build a prototype",
              "2": "Test the solution",
              "3": "Identify the problem",
              "4": "Create a budget"
            },
            "correctOptionKey": "3"
          }
        }
      },
      "Applied Engineering Concepts": {
        "image_url": "https://img.freepik.com/premium-photo/technical-engineering-drawing-precision-detail-industrial-design-machinery-construction_875722-56138.jpg?w=1800",
        "lessons": {
          "lesson1": {
            "title": "1. Forces and Motion",
            "content": "Learn how forces affect motion and how to calculate net forces."
          },
          "lesson2": {
            "title": "2. Material Properties",
            "content": "Examine different materials used in engineering and their physical properties."
          }
        },
        "quiz": {
          "0": {
            "questionText": "What is the unit of force in the SI system?",
            "options": {
              "1": "Joule",
              "2": "Watt",
              "3": "Pascal",
              "4": "Newton"
            },
            "correctOptionKey": "4"
          },
          "1": {
            "questionText": "Which property describes a material's resistance to deformation?",
            "options": {
              "1": "Elasticity",
              "2": "Density",
              "3": "Conductivity",
              "4": "Transparency"
            },
            "correctOptionKey": "1"
          },
          "2": {
            "questionText": "If a 10 N force is applied to a 2 kg object, what is its acceleration?",
            "options": {
              "1": "2 m/s²",
              "2": "5 m/s²",
              "3": "10 m/s²",
              "4": "20 m/s²"
            },
            "correctOptionKey": "2"
          }
        }
      }
    }
  },

  "Science": {
    "title": "Science",
    "image_url": "https://img.freepik.com/free-vector/hand-drawn-science-education-background_23-2148499325.jpg?t=st=1742829765~exp=1742833365~hmac=19fbe0d6095234b2ad8c8d876756f46d1c2b7a2696454a427621aac807811200&w=2000",
    "courses": {
      "Basic Science Concepts": {
        "image_url": "https://img.freepik.com/free-vector/flat-design-concept-science-word_23-2148536280.jpg?ga=GA1.1.1796863793.1743803859&semt=ais_hybrid&w=740",
        "lessons": {
          "lesson1": {
            "title": "1. States of Matter",
            "content": "Learn about solids, liquids, gases, and how matter changes from one state to another."
          },
          "lesson2": {
            "title": "2. Energy Forms and Sources",
            "content": "Explore different types of energy including thermal, kinetic, potential, and renewable sources."
          }
        },
        "quiz": {
          "0": {
            "questionText": "Which of the following is NOT a state of matter?",
            "options": {
              "1": "Solid",
              "2": "Liquid",
              "3": "Gas",
              "4": "Light"
            },
            "correctOptionKey": "4"
          },
          "1": {
            "questionText": "Which energy source is renewable?",
            "options": {
              "1": "Coal",
              "2": "Oil",
              "3": "Wind",
              "4": "Natural Gas"
            },
            "correctOptionKey": "3"
          },
          "2": {
            "questionText": "What is the process of changing from a solid to a liquid called?",
            "options": {
              "1": "Freezing",
              "2": "Condensation",
              "3": "Melting",
              "4": "Evaporation"
            },
            "correctOptionKey": "3"
          }
        }
      },
      "Scientific Inquiry and Methods": {
        "image_url": "https://img.freepik.com/free-vector/flat-biotechnology-concept-illustration_23-2148892121.jpg?ga=GA1.1.1796863793.1743803859&semt=ais_hybrid&w=740",
        "lessons": {
          "lesson1": {
            "title": "1. The Scientific Method",
            "content": "Understand the steps of the scientific method from asking questions to drawing conclusions."
          },
          "lesson2": {
            "title": "2. Conducting Experiments",
            "content": "Learn how to design, conduct, and interpret experiments using proper controls and variables."
          }
        },
        "quiz": {
          "0": {
            "questionText": "What is the first step in the scientific method?",
            "options": {
              "1": "Analyze Data",
              "2": "Conduct an Experiment",
              "3": "Ask a Question",
              "4": "Form a Hypothesis"
            },
            "correctOptionKey": "3"
          },
          "1": {
            "questionText": "What is a variable in an experiment?",
            "options": {
              "1": "A constant condition",
              "2": "A type of conclusion",
              "3": "A part that changes",
              "4": "An error in measurement"
            },
            "correctOptionKey": "3"
          },
          "2": {
            "questionText": "Why is it important to repeat an experiment?",
            "options": {
              "1": "To get a higher grade",
              "2": "To make it more fun",
              "3": "To confirm the results",
              "4": "To change the outcome"
            },
            "correctOptionKey": "3"
          }
        }
      }
    }
  },

  "Social Studies": {
    "title": "Social Studies",
    "image_url": "https://img.freepik.com/free-vector/geopraphy-concept-with-retro-cartoon-school-lesson-set_1284-7502.jpg?ga=GA1.1.222963692.1743719257&semt=ais_hybrid&w=740",
    "courses": {
      "World History Overview": {
        "image_url": "https://img.freepik.com/free-photo/plane-magnifying-glass-near-compass-notebook_23-2147793455.jpg?ga=GA1.1.1796863793.1743803859&semt=ais_hybrid&w=740",
        "lessons": {
          "lesson1": {
            "title": "1. Ancient Civilizations",
            "content": "Explore the origins and contributions of ancient civilizations such as Mesopotamia, Egypt, and the Indus Valley."
          },
          "lesson2": {
            "title": "2. Modern World History",
            "content": "Understand key global events from the Renaissance to the 20th century including revolutions and world wars."
          }
        },
        "quiz": {
          "0": {
            "questionText": "Which civilization is known for building pyramids?",
            "options": {
              "1": "Mesopotamia",
              "2": "Greece",
              "3": "Egypt",
              "4": "Rome"
            },
            "correctOptionKey": "3"
          },
          "1": {
            "questionText": "The Renaissance began in which country?",
            "options": {
              "1": "France",
              "2": "Germany",
              "3": "England",
              "4": "Italy"
            },
            "correctOptionKey": "4"
          },
          "2": {
            "questionText": "World War II ended in what year?",
            "options": {
              "1": "1940",
              "2": "1945",
              "3": "1950",
              "4": "1939"
            },
            "correctOptionKey": "2"
          }
        }
      },
      "Cultural Anthropology": {
        "image_url": "https://img.freepik.com/free-vector/africa-travel-background_98292-7453.jpg?ga=GA1.1.1796863793.1743803859&semt=ais_hybrid&w=740",
        "lessons": {
          "lesson1": {
            "title": "1. Introduction to Culture",
            "content": "Learn about what culture is, including beliefs, customs, language, and traditions."
          },
          "lesson2": {
            "title": "2. Human Societies and Structures",
            "content": "Examine how societies are organized, including family units, governments, and economic systems."
          }
        },
        "quiz": {
          "0": {
            "questionText": "What does cultural anthropology primarily study?",
            "options": {
              "1": "Ancient fossils",
              "2": "Physical traits of humans",
              "3": "Cultural practices and beliefs",
              "4": "Weather patterns"
            },
            "correctOptionKey": "3"
          },
          "1": {
            "questionText": "Which of the following is an example of a cultural tradition?",
            "options": {
              "1": "Photosynthesis",
              "2": "Thanksgiving dinner",
              "3": "Erosion",
              "4": "Gravity"
            },
            "correctOptionKey": "2"
          },
          "2": {
            "questionText": "A matriarchal society is led primarily by:",
            "options": {
              "1": "Children",
              "2": "Elders",
              "3": "Women",
              "4": "Men"
            },
            "correctOptionKey": "3"
          }
        }
      }
    }
  },

  "Economics": {
    "title": "Economics",
    "image_url": "https://img.freepik.com/free-vector/economic-growth_24877-49241.jpg?t=st=1742829891~exp=1742833491~hmac=0d53498aa637a9366ce1779d2e3584f8aea820dea79ec3000ade2c2eba5cb004&w=1380",
    "courses": {
      "Microeconomics Essentials": {
        "image_url": "https://img.freepik.com/free-vector/business-investors-balancing-scales-achieving-profit-growth_74855-20004.jpg?ga=GA1.1.1796863793.1743803859&semt=ais_hybrid&w=740",
        "lessons": {
          "lesson1": {
            "title": "1. Supply and Demand",
            "content": "Understand how supply and demand interact to determine prices in a market economy."
          },
          "lesson2": {
            "title": "2. Market Structures",
            "content": "Explore different types of market structures including perfect competition, monopoly, and oligopoly."
          }
        },
        "quiz": {
          "0": {
            "questionText": "What happens when demand increases and supply remains unchanged?",
            "options": {
              "1": "Price falls",
              "2": "Price rises",
              "3": "Supply increases",
              "4": "Demand decreases"
            },
            "correctOptionKey": "2"
          },
          "1": {
            "questionText": "Which market structure has many sellers and identical products?",
            "options": {
              "1": "Monopoly",
              "2": "Oligopoly",
              "3": "Perfect competition",
              "4": "Monopolistic competition"
            },
            "correctOptionKey": "3"
          },
          "2": {
            "questionText": "In economics, what is 'opportunity cost'?",
            "options": {
              "1": "The cost of labor",
              "2": "The price of goods",
              "3": "The value of the next best alternative",
              "4": "The total cost of production"
            },
            "correctOptionKey": "3"
          }
        }
      },
      "Macroeconomics Fundamentals": {
        "image_url": "https://img.freepik.com/free-vector/macroeconomics-flat-vector-illustration-with-globe-image-centre-currency-tied-balloons-kettlebells-symbolizing-changing-market_1284-76978.jpg?ga=GA1.1.1796863793.1743803859&semt=ais_hybrid&w=740",
        "lessons": {
          "lesson1": {
            "title": "1. GDP and Economic Growth",
            "content": "Learn what Gross Domestic Product (GDP) is and how it measures the health of an economy."
          },
          "lesson2": {
            "title": "2. Inflation and Unemployment",
            "content": "Understand the causes and impacts of inflation and unemployment on the economy."
          }
        },
        "quiz": {
          "0": {
            "questionText": "What does GDP stand for?",
            "options": {
              "1": "Gross Development Product",
              "2": "Gross Domestic Product",
              "3": "Global Domestic Pricing",
              "4": "Government Debt Percentage"
            },
            "correctOptionKey": "2"
          },
          "1": {
            "questionText": "High inflation typically means:",
            "options": {
              "1": "Falling prices",
              "2": "Stable economy",
              "3": "Rising prices",
              "4": "Lower employment"
            },
            "correctOptionKey": "3"
          },
          "2": {
            "questionText": "What is unemployment?",
            "options": {
              "1": "People choosing not to work",
              "2": "People without jobs who are actively seeking work",
              "3": "Retired individuals",
              "4": "Part-time workers"
            },
            "correctOptionKey": "2"
          }
        }
      }
    }
  },

  "Business": {
    "title": "Business",
    "image_url": "https://img.freepik.com/free-photo/group-diverse-people-having-business-meeting_53876-25060.jpg?ga=GA1.1.222963692.1743719257&semt=ais_hybrid&w=740",
    "courses": {
      "Business Management 101": {
        "image_url": "https://images.pexels.com/photos/416405/pexels-photo-416405.jpeg?auto=compress&cs=tinysrgb&w=1600",
        "lessons": {
          "lesson1": {
            "title": "1. Principles of Management",
            "content": "Learn the core functions of management including planning, organizing, leading, and controlling."
          },
          "lesson2": {
            "title": "2. Organizational Structures",
            "content": "Explore different types of business structures such as hierarchical, flat, and matrix organizations."
          }
        },
        "quiz": {
          "0": {
            "questionText": "Which of the following is NOT a function of management?",
            "options": {
              "1": "Leading",
              "2": "Organizing",
              "3": "Inventing",
              "4": "Planning"
            },
            "correctOptionKey": "3"
          },
          "1": {
            "questionText": "A flat organizational structure typically has:",
            "options": {
              "1": "Many levels of management",
              "2": "Few levels of hierarchy",
              "3": "Strict reporting lines",
              "4": "No leadership roles"
            },
            "correctOptionKey": "2"
          },
          "2": {
            "questionText": "Which management function involves evaluating performance?",
            "options": {
              "1": "Planning",
              "2": "Controlling",
              "3": "Organizing",
              "4": "Leading"
            },
            "correctOptionKey": "2"
          }
        }
      },
      "Entrepreneurship and Innovation": {
        "image_url": "https://cdn.pixabay.com/photo/2016/11/18/22/44/blueprints-1837238_1280.jpg",
        "lessons": {
          "lesson1": {
            "title": "1. What is Entrepreneurship?",
            "content": "Define entrepreneurship and learn about the characteristics of successful entrepreneurs."
          },
          "lesson2": {
            "title": "2. From Idea to Startup",
            "content": "Explore how to develop a business idea, validate it, and build a minimum viable product (MVP)."
          }
        },
        "quiz": {
          "0": {
            "questionText": "Entrepreneurs are best known for:",
            "options": {
              "1": "Avoiding risk",
              "2": "Following instructions",
              "3": "Starting and growing businesses",
              "4": "Working in government"
            },
            "correctOptionKey": "3"
          },
          "1": {
            "questionText": "What does MVP stand for in a startup context?",
            "options": {
              "1": "Most Valuable Partner",
              "2": "Minimum Viable Product",
              "3": "Market Value Proposition",
              "4": "Major Venture Pitch"
            },
            "correctOptionKey": "2"
          },
          "2": {
            "questionText": "Which of the following is a trait commonly associated with entrepreneurs?",
            "options": {
              "1": "Risk aversion",
              "2": "Creativity",
              "3": "Conformity",
              "4": "Indecisiveness"
            },
            "correctOptionKey": "2"
          }
        }
      }
    }
  },

  "Language Arts": {
    "title": "Language Arts",
    "image_url": "https://img.freepik.com/free-vector/flat-international-mother-language-day-illustration_23-2149219243.jpg?ga=GA1.1.222963692.1743719257&semt=ais_hybrid&w=740",
    "courses": {
      "Reading Comprehension Strategies": {
        "image_url": "https://img.freepik.com/free-vector/hand-drawn-english-book-background_23-2149483336.jpg?ga=GA1.1.1796863793.1743803859&semt=ais_hybrid&w=740",
        "lessons": {
          "lesson1": {
            "title": "1. Finding the Main Idea",
            "content": "Learn how to identify the main idea and supporting details in a passage."
          },
          "lesson2": {
            "title": "2. Making Inferences",
            "content": "Practice drawing conclusions and reading between the lines using context clues."
          }
        },
        "quiz": {
          "0": {
            "questionText": "What is the main idea of a passage?",
            "options": {
              "1": "The title of the story",
              "2": "The most important point the author makes",
              "3": "A fun fact from the text",
              "4": "The first sentence"
            },
            "correctOptionKey": "2"
          },
          "1": {
            "questionText": "Which clue helps you make an inference?",
            "options": {
              "1": "The author’s name",
              "2": "Chapter number",
              "3": "Contextual hints in the text",
              "4": "Page count"
            },
            "correctOptionKey": "3"
          },
          "2": {
            "questionText": "Supporting details are used to:",
            "options": {
              "1": "Summarize the text",
              "2": "Explain the title",
              "3": "Support the main idea",
              "4": "Add random facts"
            },
            "correctOptionKey": "3"
          }
        }
      },
      "Creative Writing Fundamentals": {
        "image_url": "https://img.freepik.com/free-vector/watercolor-literature-illustration_52683-81536.jpg?ga=GA1.1.1796863793.1743803859&semt=ais_hybrid&w=740",
        "lessons": {
          "lesson1": {
            "title": "1. Story Elements",
            "content": "Understand key elements of storytelling such as character, setting, plot, and conflict."
          },
          "lesson2": {
            "title": "2. Writing Dialogue",
            "content": "Learn how to create natural-sounding dialogue that develops characters and moves the plot forward."
          }
        },
        "quiz": {
          "0": {
            "questionText": "Which of the following is a key element of a story?",
            "options": {
              "1": "Index",
              "2": "Setting",
              "3": "Footnote",
              "4": "Glossary"
            },
            "correctOptionKey": "2"
          },
          "1": {
            "questionText": "Why is dialogue important in a story?",
            "options": {
              "1": "To confuse the reader",
              "2": "To make characters more realistic",
              "3": "To replace the plot",
              "4": "To describe the setting"
            },
            "correctOptionKey": "2"
          },
          "2": {
            "questionText": "What is the conflict in a story?",
            "options": {
              "1": "The resolution",
              "2": "The background setting",
              "3": "The struggle between opposing forces",
              "4": "A list of characters"
            },
            "correctOptionKey": "3"
          }
        }
      }
    }
  }
};
