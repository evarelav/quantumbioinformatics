namespace QuantumDNAAlignment {
    // Author: Emmanuel Varela Villegas (emmanuel.varela.villegas@intel.com)
    // This Q# program demonstrates quantum encoding and comparison of DNA sequences.
    // It is designed for educational purposes to illustrate how quantum computing 
    // can be applied to bioinformatics, particularly DNA sequence alignment.

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;

    // Encodes a DNA sequence into qubits. Each DNA base is represented using 2 qubits.
    operation EncodeDNA(dna: String[], qubits: Qubit[]) : Unit {
        for i in 0..Length(dna)-1 {
            let base = dna[i];
            let q1 = qubits[2 * i];     
            let q2 = qubits[2 * i + 1]; 

            if base == "C" { X(q2); }      // Encode 'C' as 01
            elif base == "G" { X(q1); }    // Encode 'G' as 10
            elif base == "T" { X(q1); X(q2); } // Encode 'T' as 11
            // 'A' is encoded as 00 (default |0⟩ state)
        }
    }

    // Compares two DNA sequences by applying CNOT gates between corresponding qubits.
    operation CompareDNA(humanQubits: Qubit[], chimpQubits: Qubit[]) : Unit {
        for i in 0..Length(humanQubits)-1 {
            CNOT(humanQubits[i], chimpQubits[i]);
        }
    }

    // Measures the differences in DNA sequences by checking the final quantum states.
    operation MeasureDifferences(qubits: Qubit[]) : Int[] {
        mutable results = [];
        for i in 0..Length(qubits)-1 {
            let outcome = M(qubits[i]);
            set results += [outcome == One ? 1 | 0];
        }
        return results;
    }

    @EntryPoint()
    operation Run() : Unit {
        let humanDNA = ["A", "T", "G", "G", "T", "G", "C", "A"];
        let chimpDNA = ["A", "T", "G", "G", "T", "A", "C", "A"];
        let length = Length(humanDNA) * 2; // 2 qubits per base

        use humanQubits = Qubit[length];
        use chimpQubits = Qubit[length];

        EncodeDNA(humanDNA, humanQubits);
        EncodeDNA(chimpDNA, chimpQubits);
        CompareDNA(humanQubits, chimpQubits);
        
        let differences = MeasureDifferences(chimpQubits);

        Message("\nQuantum DNA Alignment:");
        Message($"Human DNA: {humanDNA}");
        Message($"Chimp DNA: {chimpDNA}");
        Message($"Differences: {differences}");

        ResetAll(humanQubits);
        ResetAll(chimpQubits);
    }
}
