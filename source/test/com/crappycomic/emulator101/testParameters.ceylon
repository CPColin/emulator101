"Every value a [[Boolean]] can have."
{Boolean*} testBooleanParameters = `Boolean`.caseValues;

"Every value a [[Byte]] can have."
{Byte*} testByteParameters = 0.byte..255.byte;

"Interesting values a register can have."
{Byte*} testRegisterParameters = {
    #00,
    #01,
    #0f,
    #10,
    #11,
    #2e,
    #7f,
    #80,
    #81,
    #a0,
    #fe,
    #ff
}*.byte;

"Augments [[Iterable.product]] to support streams that already have pairs of elements."
{[X, Y, Z]*} secondProduct<X, Y, Z>({[X, Y]*} xys, {Z*} zs)
        => {
            for ([x, y] in xys)
                for (z in zs)
                    [x, y, z]
        };

"Augments [[Iterable.product]] to take three streams at once."
{[X, Y, Z]*} tripleProduct<X, Y, Z>({X*} xs, {Y*} ys, {Z*} zs)
        => {
            for (x in xs)
                for (y in ys)
                    for (z in zs)
                        [x, y, z]
        };
